       IDENTIFICATION DIVISION.
       PROGRAM-ID. PTPOSTDS.
      ******************************************************************
      * PROGRAM: PTPOSTDS - Post Dose Record
      * DESCRIPTION: CICS program to record a dose taken via REST API
      * AUTHOR: System Generated
      * DATE: 2026-03-05
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
      * Copy API communication area
       COPY APICOMM.
       
      * SQL Communication Area
       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.
       
      * Working variables
       01  WS-RESPONSE-LENGTH      PIC 9(08) COMP VALUE ZERO.
       01  WS-JSON-POSITION        PIC 9(08) COMP VALUE 1.
       01  WS-PRESC-ID-INPUT       PIC 9(09) COMP VALUE ZERO.
       01  WS-TAKEN-TS-INPUT       PIC X(26).
       01  WS-NEW-DOSE-ID          PIC 9(09) COMP VALUE ZERO.
       
      * JSON building fields
       01  WS-JSON-OPEN-BRACE      PIC X(01) VALUE '{'.
       01  WS-JSON-CLOSE-BRACE     PIC X(01) VALUE '}'.
       01  WS-JSON-COMMA           PIC X(01) VALUE ','.
       01  WS-JSON-QUOTE           PIC X(01) VALUE '"'.
       01  WS-JSON-COLON           PIC X(01) VALUE ':'.
       
       LINKAGE SECTION.
       01  DFHCOMMAREA             PIC X(32767).
       
       PROCEDURE DIVISION.
       
       MAIN-LOGIC.
           PERFORM INITIALIZE-PROGRAM
           PERFORM PARSE-JSON-REQUEST
           PERFORM INSERT-DOSE-RECORD
           PERFORM BUILD-JSON-RESPONSE
           PERFORM SEND-RESPONSE
           EXEC CICS RETURN END-EXEC
           GOBACK.
       
       INITIALIZE-PROGRAM.
           MOVE SPACES TO JSON-RESPONSE-BUFFER
           MOVE 1 TO WS-JSON-POSITION
           MOVE ZERO TO WS-NEW-DOSE-ID.
       
       PARSE-JSON-REQUEST.
      * Parse JSON request body
      * Expected: {"prescription_id":1,"taken_at":"2026-03-05..."}
      * In real implementation, use JSON parser
      * For now, assume values are passed via API-COMM-AREA
           
           MOVE API-REQUEST-ID TO WS-PRESC-ID-INPUT
           
      * Get current timestamp if not provided
           EXEC SQL
               SELECT CURRENT TIMESTAMP
               INTO :WS-TAKEN-TS-INPUT
               FROM SYSIBM.SYSDUMMY1
           END-EXEC.
       
       INSERT-DOSE-RECORD.
      * Get next sequence value for dose ID
           EXEC SQL
               SELECT NEXT VALUE FOR PILLTRK.DOSE_SEQ
               INTO :WS-NEW-DOSE-ID
               FROM SYSIBM.SYSDUMMY1
           END-EXEC
           
           IF SQLCODE NOT = 0
               MOVE 500 TO API-RESPONSE-CODE
               MOVE 'Error generating dose ID' TO API-ERROR-MSG
               GO TO INSERT-DOSE-EXIT
           END-IF
           
      * Insert dose record
           EXEC SQL
               INSERT INTO PILLTRK.DOSE_HIST
                   (DOSE_ID, PRESC_ID, TAKEN_TS)
               VALUES
                   (:WS-NEW-DOSE-ID,
                    :WS-PRESC-ID-INPUT,
                    :WS-TAKEN-TS-INPUT)
           END-EXEC
           
           IF SQLCODE = 0
               EXEC SQL COMMIT END-EXEC
               MOVE 201 TO API-RESPONSE-CODE
           ELSE
               EXEC SQL ROLLBACK END-EXEC
               MOVE 500 TO API-RESPONSE-CODE
               MOVE 'Error inserting dose record' TO API-ERROR-MSG
           END-IF.
       
       INSERT-DOSE-EXIT.
           EXIT.
       
       BUILD-JSON-RESPONSE.
      * Build JSON response with created dose record
      * {"id":123,"prescription_id":1,"taken_at":"2026-03-05..."}
           
           STRING WS-JSON-OPEN-BRACE
                  WS-JSON-QUOTE 'id' WS-JSON-QUOTE WS-JSON-COLON
                  WS-NEW-DOSE-ID
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'prescription_id' WS-JSON-QUOTE 
                  WS-JSON-COLON
                  WS-PRESC-ID-INPUT
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'taken_at' WS-JSON-QUOTE WS-JSON-COLON
                  WS-JSON-QUOTE
                  FUNCTION TRIM(WS-TAKEN-TS-INPUT)
                  WS-JSON-QUOTE
                  WS-JSON-CLOSE-BRACE
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING
           
           SUBTRACT 1 FROM WS-JSON-POSITION
           MOVE WS-JSON-POSITION TO WS-RESPONSE-LENGTH.
       
       SEND-RESPONSE.
      * Send HTTP response via CICS WEB
           EXEC CICS WEB SEND
               FROM(JSON-RESPONSE-BUFFER)
               LENGTH(WS-RESPONSE-LENGTH)
               MEDIATYPE('application/json')
               STATUSCODE(API-RESPONSE-CODE)
               STATUSTEXT('Created')
           END-EXEC.

* Made with Bob
