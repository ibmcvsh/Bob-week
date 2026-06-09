      ******************************************************************
      * PRESCSTR.CPY - PRESCRIPTION STRUCTURE COPYBOOK
      * Description: Data structure for prescription information
      * Used by: All programs accessing prescription data
      ******************************************************************
       01  PRESCRIPTION-RECORD.
           05  PRESC-ID                PIC 9(09) COMP.
           05  PRESC-USER-ID           PIC 9(09) COMP.
           05  PRESC-NAME              PIC X(255).
           05  PRESC-DESC              PIC X(500).
           05  PRESC-FREQ-HOURS        PIC 9(04) COMP.
           05  PRESC-CREATED-TS        PIC X(26).
           05  PRESC-LAST-TAKEN-TS     PIC X(26).
           
       01  PRESCRIPTION-ARRAY.
           05  PRESC-COUNT             PIC 9(04) COMP VALUE ZERO.
           05  PRESC-ENTRY OCCURS 100 TIMES
                                       INDEXED BY PRESC-IDX.
               10  PA-PRESC-ID         PIC 9(09) COMP.
               10  PA-USER-ID          PIC 9(09) COMP.
               10  PA-PRESC-NAME       PIC X(255).
               10  PA-PRESC-DESC       PIC X(500).
               10  PA-FREQ-HOURS       PIC 9(04) COMP.
               10  PA-CREATED-TS       PIC X(26).
               10  PA-LAST-TAKEN-TS    PIC X(26).

# Made with Bob
