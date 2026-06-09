       IDENTIFICATION DIVISION.
       PROGRAM-ID. PTGETURS.
      ******************************************************************
      * PROGRAM: PTGETURS - Pill Tracker Get Users REST API
      * DESCRIPTION: CICS program to retrieve all users via REST API
      * AUTHOR: System Generated
      * DATE: 2026-03-05
      ******************************************************************
       
       ENVIRONMENT DIVISION.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
      * Copy API communication area
       COPY APICOMM.
       
      * Copy user structure
       COPY USERSTR.
       
      * SQL Communication Area
       EXEC SQL
           INCLUDE SQLCA
       END-EXEC.
       
      * Working variables
       01  WS-RESPONSE-LENGTH      PIC 9(08) COMP VALUE ZERO.
       01  WS-JSON-POSITION        PIC 9(08) COMP VALUE 1.
       01  WS-USER-COUNTER         PIC 9(04) COMP VALUE ZERO.
       01  WS-SQLCODE-DISP         PIC ----9.
       
      * JSON building fields
       01  WS-JSON-OPEN-BRACKET    PIC X(01) VALUE '['.
       01  WS-JSON-CLOSE-BRACKET   PIC X(01) VALUE ']'.
       01  WS-JSON-OPEN-BRACE      PIC X(01) VALUE '{'.
       01  WS-JSON-CLOSE-BRACE     PIC X(01) VALUE '}'.
       01  WS-JSON-COMMA           PIC X(01) VALUE ','.
       01  WS-JSON-QUOTE           PIC X(01) VALUE '"'.
       01  WS-JSON-COLON           PIC X(01) VALUE ':'.
       
      * Cursor declaration
       EXEC SQL
           DECLARE USER_CURSOR CURSOR FOR
           SELECT USER_ID, USER_NAME, CREATED_TS
           FROM PILLTRK.USERS
           ORDER BY USER_ID
       END-EXEC.
       
       LINKAGE SECTION.
       01  DFHCOMMAREA             PIC X(32767).
       
       PROCEDURE DIVISION.
       
       MAIN-LOGIC.
           PERFORM INITIALIZE-PROGRAM
           PERFORM FETCH-USERS
           PERFORM BUILD-JSON-RESPONSE
           PERFORM SEND-RESPONSE
           EXEC CICS RETURN END-EXEC
           GOBACK.
       
       INITIALIZE-PROGRAM.
           MOVE SPACES TO JSON-RESPONSE-BUFFER
           MOVE 1 TO WS-JSON-POSITION
           MOVE ZERO TO WS-USER-COUNTER
           MOVE ZERO TO USER-COUNT.
       
       FETCH-USERS.
      * Open cursor
           EXEC SQL
               OPEN USER_CURSOR
           END-EXEC
           
           IF SQLCODE NOT = 0
               MOVE 500 TO API-RESPONSE-CODE
               MOVE 'Database error opening cursor' TO API-ERROR-MSG
               GO TO FETCH-USERS-EXIT
           END-IF
           
      * Fetch all users
           PERFORM FETCH-USER-LOOP
               UNTIL SQLCODE NOT = 0
           
      * Close cursor
           EXEC SQL
               CLOSE USER_CURSOR
           END-EXEC.
       
       FETCH-USERS-EXIT.
           EXIT.
       
       FETCH-USER-LOOP.
           EXEC SQL
               FETCH USER_CURSOR
               INTO :USER-ID,
                    :USER-NAME,
                    :USER-CREATED-TS
           END-EXEC
           
           IF SQLCODE = 0
               ADD 1 TO USER-COUNT
               ADD 1 TO WS-USER-COUNTER
               MOVE USER-ID TO UA-USER-ID(USER-COUNT)
               MOVE USER-NAME TO UA-USER-NAME(USER-COUNT)
               MOVE USER-CREATED-TS TO UA-CREATED-TS(USER-COUNT)
           END-IF.
       
       BUILD-JSON-RESPONSE.
      * Start JSON array
           STRING WS-JSON-OPEN-BRACKET
               DELIMITED BY SIZE
               INTO JSON-RESPONSE-BUFFER
               WITH POINTER WS-JSON-POSITION
           END-STRING
           
      * Build JSON for each user
           PERFORM VARYING USER-IDX FROM 1 BY 1
               UNTIL USER-IDX > USER-COUNT
               
               IF USER-IDX > 1
                   STRING WS-JSON-COMMA
                       DELIMITED BY SIZE
                       INTO JSON-RESPONSE-BUFFER
                       WITH POINTER WS-JSON-POSITION
                   END-STRING
               END-IF
               
               PERFORM BUILD-USER-JSON
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
       
       BUILD-USER-JSON.
      * Build JSON object for one user
      * {"id":1,"name":"Sarah Johnson","created_at":"2026-03-05..."}
           
           STRING WS-JSON-OPEN-BRACE
                  WS-JSON-QUOTE 'id' WS-JSON-QUOTE WS-JSON-COLON
                  UA-USER-ID(USER-IDX)
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'name' WS-JSON-QUOTE WS-JSON-COLON
                  WS-JSON-QUOTE
                  FUNCTION TRIM(UA-USER-NAME(USER-IDX))
                  WS-JSON-QUOTE
                  WS-JSON-COMMA
                  WS-JSON-QUOTE 'created_at' WS-JSON-QUOTE WS-JSON-COLON
                  WS-JSON-QUOTE
                  FUNCTION TRIM(UA-CREATED-TS(USER-IDX))
                  WS-JSON-QUOTE
                  WS-JSON-CLOSE-BRACE
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
