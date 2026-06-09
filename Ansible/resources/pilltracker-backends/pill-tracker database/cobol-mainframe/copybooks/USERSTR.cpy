      ******************************************************************
      * USERSTR.CPY - USER STRUCTURE COPYBOOK
      * Description: Data structure for user information
      * Used by: All programs accessing user data
      ******************************************************************
       01  USER-RECORD.
           05  USER-ID                 PIC 9(09) COMP.
           05  USER-NAME               PIC X(255).
           05  USER-CREATED-TS         PIC X(26).
           
       01  USER-ARRAY.
           05  USER-COUNT              PIC 9(04) COMP VALUE ZERO.
           05  USER-ENTRY OCCURS 100 TIMES
                                       INDEXED BY USER-IDX.
               10  UA-USER-ID          PIC 9(09) COMP.
               10  UA-USER-NAME        PIC X(255).
               10  UA-CREATED-TS       PIC X(26).

# Made with Bob
