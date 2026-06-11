## Welcome to the watsonx Assistant for Z Session for Bob Week! 

### Lab Overview

In this lab, you will learn how to use IBM Bob and the watsonx Orchestrate Agent Development Kit (ADK) to create a custom agent for watsonx Assistant for Z. Users will use this custom agent to run skeleton/template jobs with new parameters that the user provides. To do this You will complete three main activities:

1. **Create Connections** - Set up a connection to the z/OSMF API with authentication credentials

2. **Create Python Tools** - Build 5 Python tools that leverage the z/OSMF API to:
   - Read a dataset. We do this to confirm with the user that this is the template/skeleton job they wish to run
   - Create a new dataset. This tool creates a new dataset so the original skeleton/template job is not overwritten.
   - Write to a dataset. This tool writes the modified JCL to the new dataset.
   - Submit a job. This will actually run the JCL.
   - Get the status of a submitted job. This tool will get the status and output of the job.

3. **Create an Agent** - Build an agent that orchestrates these tools to help users run skeleton/template jobs with custom parameters

All components (tools, connections, and agents) will be uploaded to watsonx Asisstant for Z using the **Orchestrate CLI**.

---

## Part 1 - Set Up Your Environment 🛠️

IBM Client Engineering Team will walk through how to set up your environment for the lab. They will show you how to:

1. Access your watsonx Orchestrate instance

2. Get your Orchestrate service instance and API key

3. Open IBM Bob and help login if necessary

4. Open a terminal in Bob and navigate to the Bob-week repo that is already cloned to your computer

5. Activate the virtual environment where git and orchestrate cli are installed

6. Login to your orchestrate instance via the orchestrate cli. To login, enter the following commands in the Bob Terminal (replacing < orchestrate service instance url > with the service instance you found in step 2):
   ```bash
   orchestrate env add -n wxa4z-bobweek -u <orchestrate service instance url>
   orchestrate env activate wxa4z-bobweek
   ```

7. Use git to pull from the lab repository's main branch to get the most recent lab guide:
   ```bash
   git pull origin main
   cd wxa4z
   ```

8. Finally, open this repo's wxa4z folder in IBM Bob.

You're all set now! Now we will start using Bob to create a custom agent for watsonx Assistant for Z. 

---

## Step 2 - Create Connection (Activity 1 of 3) 🔌

First thing we need to do is create a **connection to the z/OSMF API** so your tools can authenticate and communicate with the z/OS backend.

9. In the IBM Bob chat box, ask Bob to:
   ```
   Create a connection to the zosmf api using the watsonx Orchestrate ADK. Use the following link as reference: https://developer.watson-orchestrate.ibm.com/connections/build_connections. Use the connection.yaml file in the sample_files folder as a reference and template. You will use basic auth with Team credentials for both draft and live. The server url is https://52.118.209.149:10443/ . Create a folder called connections and put this new file in that folder.
   ```

10. Once the connection is created, **upload it using the Orchestrate CLI** and then set the credentials by running the following 2 commands in the Terminal:
    ```bash
    orchestrate connections import -f zosmf_connection.yaml
    ```

    ```bash
    orchestrate connections set-credentials -a zosmf \
    --env draft \
    -u IBMUSER \
    -p wxa4zBobweekAgent5Bootcamp!
    ```
    
    ```bash
    orchestrate connections set-credentials -a zosmf \
    --env live \
    -u IBMUSER \
    -p wxa4zBobweekAgent5Bootcamp!
    ```

---

## Step 3 - Create Python Tools (Activity 2 of 3) 🐍

In this section, you will create **5 Python tools** that leverage the **z/OSMF API** to interact with z/OS datasets and jobs. Each tool will be uploaded to watsonx Assistant for Z using the **Orchestrate CLI**.

### Tool 1: Read Dataset Tool 📖

11. This tool reads the contents of a z/OS dataset. In IBM Bob chat window, enter the prompt:
    ```
    Create a python tool in the watsonx Orchestrate ADK that reaches out to the zosmf api to read the contents of the dataset. The tool should return the contents/output of the dataset read api call. It should take in the dataset name as input. Use this link for context on the the zosmf api read dataset api syntax: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-retrieve-contents-zos-data-set-member. Use this link for context on how to make a python tool in the ADK: https://developer.watson-orchestrate.ibm.com/tools/create_tool. Make sure the tool has the decorators and input that the ADK needs to know to know about the tool: https://developer.watson-orchestrate.ibm.com/tools/create_tool. See the files operatorCommand.py and tsoCommand.py in the sample_files folder as reference and a template when making the read_dataset tool. Create a folder called tools and put this new tool in that folder.
    ```

12. After creating the tool, upload it using the Orchestrate CLI in the Terminal:
    ```bash
    orchestrate tools import -k python -f tools/read_dataset.py --app-id zosmf
    ```

### Tool 2: Create Dataset Tool ➕

13. This tool creates a new z/OS dataset. In IBM Bob, enter the prompt:
    ```
    Create a python tool in the watsonx Orchestrate ADK that reaches out to the zosmf api to create a new dataset. The tool should take in the new dataset name as input. Use this link for context on the the zosmf api write dataset api syntax: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-create-sequential-partitioned-data-set. Use this link for context on how to make a python tool in the ADK: https://developer.watson-orchestrate.ibm.com/tools/create_tool. Make sure the tool has the decorators and input that the ADK needs to know to know about the tool: https://developer.watson-orchestrate.ibm.com/tools/create_tool. See the files operatorCommand.py and tsoCommand.py in the sample_files folder as reference and a template when making the create_dataset tool. Put this new tool in the tools/ folder
    ```

14. After creating the tool, upload it using the Orchestrate CLI in the Terminal:
    ```
    orchestrate tools import -k python -f tools/create_dataset.py --app-id zosmf
    ```

### Tool 3: Write to Dataset Tool ✍️

15. This tool writes content to an existing z/OS dataset. In IBM Bob, enter the prompt:
    ```
    Create a python tool in the watsonx Orchestrate ADK that reaches out to the zosmf api to write to a dataset. The tool should take in the dataset name as input. Use this link for context on the the zosmf api write dataset api syntax: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-write-data-zos-data-set-member. Use this link for context on how to make a python tool in the ADK: https://developer.watson-orchestrate.ibm.com/tools/create_tool. Make sure the tool has the decorators and input that the ADK needs to know to know about the tool: https://developer.watson-orchestrate.ibm.com/tools/create_tool. See the files operatorCommand.py and tsoCommand.py in the sample_files folder as reference and a template when making the write_dataset tool. Put this new tool in the tools/ folder
    ```

16. After creating the tool, upload it using the Orchestrate CLI:
    ```
    orchestrate tools import -k python -f tools/write_dataset.py --app-id zosmf
    ```

### Tool 4: Submit Job Tool 🚀

17. This tool submits a job to z/OS. In IBM Bob, enter the prompt:
    ```
    Create a python tool in the watsonx Orchestrate ADK that reaches out to the zosmf api to submit a job. The tool should take in the dataset name of the job they want to submit as input. Use this link for context on the the zosmf api submit job api syntax: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-submit-job Use this link for context on how to make a python tool in the ADK: https://developer.watson-orchestrate.ibm.com/tools/create_tool. Make sure the tool has the decorators and input that the ADK needs to know to know about the tool: https://developer.watson-orchestrate.ibm.com/tools/create_tool. See the files operatorCommand.py and tsoCommand.py in the sample_files folder as reference and a template when making the submit_job tool. Put this new tool in the tools/ folder
    ```

18. After creating the tool, upload it using the Orchestrate CLI:
    ```
    orchestrate tools import -k python -f tools/submit_job.py --app-id zosmf
    ```

### Tool 5: Get Job Status Tool 📊

19. This tool retrieves the status of a previously submitted job. In IBM Bob, enter the prompt:
    ```
    Create a python tool in the watsonx Orchestrate ADK that reaches out to the zosmf api to retrieve the status of the job. The tool should take in the job id of the job they want to retrieve the status of as input. Use this link for context on the the zosmf api job status api syntax: https://www.ibm.com/docs/en/zos/2.5.0?topic=interface-obtain-status-job. Note that the zosm api job status syntax requires both the job id and the job name as part of the url. Use this link for context on how to make a python tool in the ADK: https://developer.watson-orchestrate.ibm.com/tools/create_tool. Make sure the tool has the decorators and input that the ADK needs to know to know about the tool: https://developer.watson-orchestrate.ibm.com/tools/create_tool. See the files get_job_status.py in the sample_files folder as reference and a template when making the get_job_status tool. Put this new tool in the tools/ folder
    ```

20. After creating the tool, upload it using the Orchestrate CLI:
    ```
    orchestrate tools import -k python -f tools/get_job_status.py --app-id zosmf
    ```

---

## Step 4 - Create Agent (Activity 3 of 3) 🤖

Finally, you will create an **agent** that orchestrates the tools you created to help users run skeleton/template jobs with custom parameters.

21. In IBM Bob chat box, ask it to:
    ```
    Create an agent in the watsonx Orchestrate ADK and put it in a new folder called agents. Use the following link as reference: https://developer.watson-orchestrate.ibm.com/agents/build_agents. Use the IPL-validator-agent.yaml file in the sample_files folder as a template and reference. Its llm will be groq/openai/gpt-oss-120b. The agent's name will be skeleton_job_agent. Explicitly tell the agent not to hallucinate or guess ever. Write the agent's instructions field so the agent does the following in order (do not skip steps or go out of order):
    1. Take in as input the dataset name of a skeleton dataset that the user wants to run.
    2. Use your tool that reads datasets to read the dataset that the user identified in the previous step.
    3. Output the dataset contents to the user in the chat window
    4. Ask the user what parameters they want to change
    5. Tell the user that you will create a new dataset with the updated parameters. The new dataset name will be the same as the original dataset name with .NEW appended to it.
    6. Use your tool that creates datasets to create a new dataset with the new dataset name.
    7. If successful, you will tell the user that the dataset has been created successfully and that you will now write the dataset content with the updated parameters.
    8. Use your tool that writes content to dataset to write the original dataset's contents with the updated parameters to the new dataset.
    9. Read the new dataset contents using your tool and output the results to the user in the chat window.
    10. Ask the user if they want to make any more changes.
    11. If yes, overwrite the contents of the new dataset name with the updated parameters using your tool that writes to datasets
    12. If no, ask the user if they want to submit the job in the dataset
    13. If the user does want to submit the job, use your tool to run the job
    14. Wait 10 seconds and then output the status of the job using your tool to the user in the chat window.
    15. If the user does not want to submit the job, ask the user if they want to make any more changes.
    ```

22. After creating the agent, **upload it to watsonx Assistant for Z using the Orchestrate CLI**:
    ```
    orchestrate agents import -f agent/skeleton_job_agent.yaml
    ```

---

## Congratulations! 🎊

You have successfully completed all three activities:
- ✅ Created 5 Python tools that leverage the z/OSMF API
- ✅ Created a connection to the z/OSMF API
- ✅ Created an agent that orchestrates these tools

All components have been uploaded to watsonx Assistant for Z using the Orchestrate CLI. Your agent is now ready to help users run skeleton/template jobs with custom parameters!

---

## Step 5 - Test Out Your Agent! 🧪

23. Go back to the Orchestrate UI that CE showed you how to access at the beginning of this lab.

24. In the upper left hand corner, click the hamburger button

25. Click **Build**

26. You should see your agent tile! Click on the tile.

27. Ask it to run a skeleton job. There is a job already on this z/OS system called `IBMUSER.JCL.SKELETON(JOB1)`. This job runs `LISTCAT ENTRIES('SYS1.PARMLIB') ALL`. You can use this as your initial testing to see if you can listcat different datasets.

---

## Congratulations! 🏆

You used IBM Bob to write a custom agent using the watsonx Orchestrate ADK that can integrate with watsonx Assistant for Z! If you have time at the end of this lab, feel free to expand or enhance your agent or tools! Here are some ideas if you get stuck:

- Use Bob to create ansible playbooks that read, create, and write to datasets! APIs are great tools, but using playbooks as your automation base is a great way to make re-usable assets that can be integrated in many other ways across teams!
- Create another z/OSMF tool that deletes the new dataset after the job has completed successfully. Modify the agent's behavior to include this new step.
- If a job fails, modify the agent's behavior to include remediation steps or ways to investigate the problem.