import time
import requests
import json
import re
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
from urllib.parse import urljoin
from ibm_watsonx_orchestrate.run import connections
from ibm_watsonx_orchestrate.agent_builder.connections import ConnectionType, ExpectedCredentials


@tool(name="get_job_status",
      description="Retrieves the status and output of a z/OS batch job through the z/OSMF REST API. Provide both the job name (e.g., 'SKELJOB') and job ID (e.g., 'JOB12345') to get detailed status information including owner, status, return code, and job output.",
      permission=ToolPermission.READ_ONLY,
      expected_credentials=[ExpectedCredentials(
          app_id="zosmf",
          type=ConnectionType.BASIC_AUTH
      )])


def get_job_status(job_name: str, job_id: str) -> str:
    """
    Retrieves the status of a z/OS batch job using the z/OSMF REST API.
    
    Args:
        job_name: The job name (e.g., 'SKELJOB')
        job_id: The job ID (e.g., 'JOB12345')
    
    Returns:
        Detailed job status information including job name, owner, status, return code, and job output
    """
    
    conn = connections.basic_auth('zosmf')
    base_url = conn.url
    print(f"Base URL: {base_url}")
    USERNAME = conn.username
    PASSWORD = conn.password

    # Construct the API endpoint for getting job status
    # Format: /zosmf/restjobs/jobs/{jobname}/{jobid}
    # Reference: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-obtain-status-job
    job_status_url = urljoin(base_url, f'zosmf/restjobs/jobs/{job_name}/{job_id}')
    
    headers = {
        "Accept": "application/json",
        "X-CSRF-ZOSMF-HEADER": "dummy"
    }   

    try:
        # GET request to retrieve job status
        response = requests.get(
            job_status_url, 
            headers=headers, 
            auth=(USERNAME, PASSWORD), 
            verify=False
        )
        response.raise_for_status()
        
        # Parse the response to get job details
        job_data = response.json()
        
        job_id_resp = job_data.get('jobid', 'N/A')
        job_name_resp = job_data.get('jobname', 'N/A')
        owner = job_data.get('owner', 'N/A')
        status = job_data.get('status', 'N/A')
        retcode = job_data.get('retcode', 'N/A')
        job_class = job_data.get('class', 'N/A')
        phase = job_data.get('phase', 'N/A')
        phase_name = job_data.get('phase-name', 'N/A')
        subsystem = job_data.get('subsystem', 'N/A')
        
        status_msg = f"Job Status for {job_name_resp}({job_id_resp})\n"
        status_msg += f"{'='*60}\n"
        status_msg += f"Job Name: {job_name_resp}\n"
        status_msg += f"Job ID: {job_id_resp}\n"
        status_msg += f"Owner: {owner}\n"
        status_msg += f"Status: {status}\n"
        status_msg += f"Return Code: {retcode}\n"
        status_msg += f"Class: {job_class}\n"
        status_msg += f"Phase: {phase} ({phase_name})\n"
        status_msg += f"Subsystem: {subsystem}\n"
        
        # Try to get job output (spool files) if job is complete
        if status in ['OUTPUT', 'COMPLETE']:
            try:
                # Get list of spool files
                files_url = urljoin(base_url, f'zosmf/restjobs/jobs/{job_name}/{job_id}/files')
                files_response = requests.get(
                    files_url,
                    headers=headers,
                    auth=(USERNAME, PASSWORD),
                    verify=False
                )
                files_response.raise_for_status()
                files_data = files_response.json()
                
                status_msg += f"\n{'='*60}\n"
                status_msg += f"Job Output (Spool Files):\n"
                status_msg += f"{'='*60}\n"
                
                # Get content of each spool file
                for file_info in files_data:
                    ddname = file_info.get('ddname', 'UNKNOWN')
                    stepname = file_info.get('stepname', 'UNKNOWN')
                    file_id = file_info.get('id', '')
                    reccount = file_info.get('reccount', 0)
                    
                    status_msg += f"\n--- {stepname}.{ddname} (Records: {reccount}) ---\n"
                    
                    # Get the actual content of this spool file
                    if file_id:
                        content_url = urljoin(base_url, f'zosmf/restjobs/jobs/{job_name}/{job_id}/files/{file_id}/records')
                        content_response = requests.get(
                            content_url,
                            headers={"Accept": "text/plain", "X-CSRF-ZOSMF-HEADER": "dummy"},
                            auth=(USERNAME, PASSWORD),
                            verify=False
                        )
                        if content_response.status_code == 200:
                            content = content_response.text
                            # Limit output to first 50 lines per file to avoid overwhelming response
                            lines = content.split('\n')[:50]
                            status_msg += '\n'.join(lines)
                            total_lines = len(content.split('\n'))
                            if total_lines > 50:
                                remaining_lines = total_lines - 50
                                status_msg += f'\n... (output truncated, {remaining_lines} more lines)'
                        status_msg += "\n"
                        
            except Exception as e:
                status_msg += f"\nNote: Could not retrieve job output: {str(e)}\n"
        
        print(status_msg)
        return status_msg
        
    except requests.exceptions.HTTPError as e:
        error_msg = f"HTTP Error retrieving status for job {job_id}: {e}"
        if e.response is not None:
            try:
                error_details = e.response.json()
                error_msg += f"\nDetails: {json.dumps(error_details, indent=2)}"
            except:
                error_msg += f"\nResponse: {e.response.text}"
        print(error_msg)
        return error_msg
        
    except Exception as e:
        error_msg = f"Error retrieving status for job {job_id}: {str(e)}"
        print(error_msg)
        return error_msg

# Made with Bob
