      ******************************************************************
      * APICOMM.CPY - API COMMUNICATION AREA COPYBOOK
      * Description: Common communication area for REST API programs
      * Used by: All CICS REST API programs
      ******************************************************************
       01  API-COMM-AREA.
           05  API-FUNCTION            PIC X(10).
               88  API-GET-USERS       VALUE 'GETUSERS'.
               88  API-GET-USER        VALUE 'GETUSER'.
               88  API-GET-PRESCRIP    VALUE 'GETPRESC'.
               88  API-GET-PRESC-HIST  VALUE 'GETPHIST'.
               88  API-POST-DOSE       VALUE 'POSTDOSE'.
           05  API-REQUEST-ID          PIC 9(09) COMP.
           05  API-RESPONSE-CODE       PIC 9(03) COMP.
               88  API-SUCCESS         VALUE 200.
               88  API-CREATED         VALUE 201.
               88  API-BAD-REQUEST     VALUE 400.
               88  API-NOT-FOUND       VALUE 404.
               88  API-SERVER-ERROR    VALUE 500.
           05  API-ERROR-MSG           PIC X(255).
           05  API-RESPONSE-DATA       PIC X(32000).
           
       01  JSON-REQUEST-BUFFER         PIC X(32000).
       01  JSON-RESPONSE-BUFFER        PIC X(32000).
       
       01  HTTP-HEADERS.
           05  CONTENT-TYPE            PIC X(50)
               VALUE 'application/json'.
           05  CONTENT-LENGTH          PIC 9(08) COMP.

# Made with Bob
