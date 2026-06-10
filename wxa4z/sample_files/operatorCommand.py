import time
import requests
import json
import re
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
from urllib.parse import urljoin
from ibm_watsonx_orchestrate.run import connections
from ibm_watsonx_orchestrate.agent_builder.connections import ConnectionType, ExpectedCredentials


@tool(name="operatorCommand", 
      description="Issues an MVS operator command through the z/OSMF REST console services. The command is executed on the default console (defcn) and returns the command response.", 
      permission=ToolPermission.READ_ONLY,
      expected_credentials=[ExpectedCredentials(
          app_id="zosmf",
          type=ConnectionType.BASIC_AUTH
      )])


def operatorCommand(cmd: str) -> str:


    conn = connections.basic_auth('zosmf')
    base_url= conn.url
    print(base_url)
    USERNAME=conn.username
    PASSWORD=conn.password


    get_status_url = urljoin(base_url, f'restconsoles/consoles/iserVS01')
    request_body = {
        "cmd": cmd,
        "sol-key": "JES"
    }
    json_payload = json.dumps(request_body)
    
    headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-ZOSMF-HEADER": "dummy"
    }   

    status_response = requests.put(get_status_url, data=json_payload, headers=headers, auth=(USERNAME, PASSWORD), verify=False)
    status_response.raise_for_status()
    status_data=status_response.json()
    cmd_response=status_data['cmd-response'].replace('\r', '\n')
    print(cmd_response)
    return cmd_response

