       IDENTIFICATION DIVISION.
       PROGRAM-ID. PTGETPRS.
      ******************************************************************
      * PROGRAM: PTGETPRS - Get Prescriptions with History
      * DESCRIPTION: CICS program to retrieve prescriptions for a user
      *              with last dose information via REST API
      * AUTHOR: System Generated
      * DATE: 2026-03-05
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
      * Copy API communication area
       COPY APICOMM.
       
      * Copy prescription structure
       COPY PRESCSTR.
       
      * SQL Communication Area
       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.
       
      * Working variables
       01  WS-RESPONSE-LENGTH      PIC 9(08) COMP VALUE ZERO.
       01  WS-JSON-POSITION        PIC 9(08) COMP VALUE 1.
       01  WS-USER-ID-INPUT        PIC 9(09) COMP VALUE ZERO.
       
      * JSON building fields
       01  WS-JSON-OPEN-BRACKET    PIC X(01) VALUE '['.
       01  WS-JSON-CLOSE-BRACKET   PIC X(01) VALUE ']'.
       01  WS-JSON-OPEN-BRACE      PIC X(01) VALUE '{'.
       01  WS-JSON-CLOSE-BRACE     PIC X(01) VALUE '}'.
       01  WS-JSON-COMMA           PIC X(01) VALUE ','.
       01  WS-JSON-QUOTE           PIC X(01) VALUE '"'.
       01  WS-JSON-COLON           PIC X(01) VALUE ':'.
       01  WS-JSON-NULL            PIC X(04) VALUE 'null'.
       
      * Cursor declaration
       EXEC SQL
           DECLARE PRESC_CURSOR CURSOR FOR
           SELECT P.PRESC_ID,
                  P.USER_ID,
                  P.PRESC_NAME,
                  P.PRESC_DESC,
                  P.FREQ_HOURS,
                  P.CREATED_TS,
                  D.TAKEN_TS
           FROM PILLTRK.PRESCRIP P
           LEFT JOIN LATERAL (
               SELECT TAKEN_TS
               FROM PILLTRK.DOSE_HIST
               WHERE PRESC_ID = P.PRESC_ID
               ORDER BY TAKEN_TS DESC
               FETCH FIRST 1 ROW ONLY
           ) D ON 1=1
           WHERE P.USER_ID = :WS-USER-ID-INPUT
           ORDER BY P.PRESC_ID
       END-EXEC.
       
       LINKAGE SECTION.
       01  DFHCOMMAREA             PIC X(32767).
       
       PROCEDURE DIVISION.
       
       MAIN-LOGIC.
           PERFORM INITIALIZE-PROGRAM
           PERFORM GET-USER-ID-FROM-REQUEST
           PERFORM FETCH-PRESCRIPTIONS
           PERFORM BUILD-JSON-RESPONSE
           PERFORM SEND-RESPONSE
           EXEC CICS RETURN END-EXEC
           GOBACK.
       
       INITIALIZE-PROGRAM.
           MOVE SPACES TO JSON-RESPONSE-BUFFER
           MOVE 1 TO WS-JSON-POSITION
           MOVE ZERO TO PRESC-COUNT.
       
       GET-USER-ID-FROM-REQUEST.
      * Extract user ID from API request
      * In real implementation, parse from URI path
           MOVE API-REQUEST-ID TO WS-USER-ID-INPUT.
       
       FETCH-PRESCRIPTIONS.
      * Open cursor
           EXEC SQL
               OPEN PRESC_CURSOR
           END-EXEC
           
           IF SQLCODE NOT = 0
               MOVE 500 TO API-RESPONSE-CODE
               MOVE 'Database error opening cursor' TO API-ERROR-MSG
               GO TO FETCH-PRESCRIPTIONS-EXIT
           END-IF
           
      * Fetch all prescriptions
           PERFORM FETCH-PRESCRIPTION-LOOP
               UNTIL SQLCODE NOT = 0
           
      * Close cursor
           EXEC SQL
               CLOSE PRESC_CURSOR
           END-EXEC.
       
       FETCH-PRESCRIPTIONS-EXIT.
           EXIT.
       
       FETCH-PRESCRIPTION-LOOP.
           EXEC SQL
               FETCH PRESC_CURSOR
               INTO :PRESC-ID,
                    :PRESC-USER-ID,
                    :PRESC-NAME,
                    :PRESC-DESC,
                    :PRESC-FREQ-HOURS,
                    :PRESC-CREATED-TS,
                    :PRESC-LAST-TAKEN-TS
           END-EXEC
           
           IF SQLCODE = 0
               ADD 1 TO PRESC-COUNT
               MOVE PRESC-ID TO PA-PRESC-ID(PRESC-COUNT)
               MOVE PRESC-USER-ID TO PA-USER-ID(PRESC-COUNT)
               MOVE PRESC-NAME TO PA-PRESC-NAME(PRESC-COUNT)
               MOVE PRESC-DESC TO PA-PRESC-DESC(PRESC-COUNT)
               MOVE PRESC-FREQ-HOURS TO PA-FREQ-HOURS(PRESC-COUNT)
               MOVE PRESC-CREATED-TS TO PA-CREATED-TS(PRESC-COUNT)
               MOVE PRESC-LAST-TAKEN-TS TO 
                    PA-LAST-TAKEN-TS(PRESC-COUNT)
           END-IF.
       
       BUILD-JSON-RESPONSE.
      * Start JSON array
           STRING WS-JSON-OPEN-BRACKET
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING
           
      * Build JSON for each prescription
           PERFORM VARYING PRESC-IDX FROM 1 BY 1
               UNTIL PRESC-IDX > PRESC-COUNT
               
               IF PRESC-IDX > 1
                   STRING WS-JSON-COMMA
                       DELIMITED BY SIZE
                       INTO JSON-RESPONSE-BUFFER
                       WITH POINTER WS-JSON-POSITION
                   END-STRING
               END-IF
               
               PERFORM BUILD-PRESCRIPTION-JSON
           END-PERFORM
           
      * Close JSON array
           STRING WS-JSON-CLOSE-BRACKET
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING
           
           SUBTRACT 1 FROM WS-JSON-POSITION
           MOVE WS-JSON-POSITION TO WS-RESPONSE-LENGTH
           MOVE 200 TO API-RESPONSE-CODE.
       
       BUILD-PRESCRIPTION-JSON.
      * Build JSON object for one prescription
           STRING WS-JSON-OPEN-BRACE
                  WS-JSON-QUOTE 'id' WS-JSON-QUOTE WS-JSON-COLON
                  PA-PRESC-ID(PRESC-IDX)
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'user_id' WS-JSON-QUOTE WS-JSON-COLON
                  PA-USER-ID(PRESC-IDX)
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'name' WS-JSON-QUOTE WS-JSON-COLON
                  WS-JSON-QUOTE
                  FUNCTION TRIM(PA-PRESC-NAME(PRESC-IDX))
                  WS-JSON-QUOTE
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'description' WS-JSON-QUOTE 
                  WS-JSON-COLON
                  WS-JSON-QUOTE
                  FUNCTION TRIM(PA-PRESC-DESC(PRESC-IDX))
                  WS-JSON-QUOTE
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'frequency_hours' WS-JSON-QUOTE 
                  WS-JSON-COLON
                  PA-FREQ-HOURS(PRESC-IDX)
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'last_taken' WS-JSON-QUOTE 
                  WS-JSON-COLON
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING
           
      * Add last_taken timestamp or null
           IF PA-LAST-TAKEN-TS(PRESC-IDX) = SPACES
               STRING WS-JSON-NULL
                   DELIMITED BY SIZE
                   INTO JSON-RESPONSE-BUFFER
                   WITH POINTER WS-JSON-POSITION
               END-STRING
           ELSE
               STRING WS-JSON-QUOTE
                      FUNCTION TRIM(PA-LAST-TAKEN-TS(PRESC-IDX))
                      WS-JSON-QUOTE
                   DELIMITED BY SIZE
                   INTO JSON-RESPONSE-BUFFER
                   WITH POINTER WS-JSON-POSITION
               END-STRING
           END-IF
           
           STRING WS-JSON-CLOSE-BRACE
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING.
       
       SEND-RESPONSE.
      * Send HTTP response via CICS WEB
           EXEC CICS WEB SEND
               FROM(JSON-RESPONSE-BUFFER)
               LENGTH(WS-RESPONSE-LENGTH)
               MEDIATYPE('application/json')
               STATUSCODE(API-RESPONSE-CODE)
               STATUSTEXT('OK')
           END-EXEC.

* Made with Bob
