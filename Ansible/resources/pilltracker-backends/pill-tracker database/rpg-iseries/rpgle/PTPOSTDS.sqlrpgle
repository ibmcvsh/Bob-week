      **FREE
      //*****************************************************************
      //* PTPOSTDS - Post Dose Record
      //* Description: RPG ILE program to record a dose taken via REST API
      //* Author: System Generated
      //* Date: 2026-03-05
      //*****************************************************************

      Ctl-Opt DftActGrp(*No) ActGrp(*Caller) BndDir('QC2LE');

      //*****************************************************************
      //* Global Variables
      //*****************************************************************
      Dcl-S JsonResponse Varchar(32000);
      Dcl-S ResponseCode Int(10) Inz(201);
      Dcl-S PrescIdInput Int(10);
      Dcl-S TakenTsInput Timestamp;
      Dcl-S NewDoseId Int(10);

      //*****************************************************************
      //* SQL Declarations
      //*****************************************************************
      Exec SQL
        Set Option Commit = *None,
                   CloSqlCsr = *EndMod;

      //*****************************************************************
      //* Main Procedure
      //*****************************************************************
      Dcl-PI *N;
        pPrescId Int(10) Const;
        pTakenTs Timestamp Const;
        pResponse Char(32000);
        pRespCode Int(10);
      End-PI;

      // Initialize
      JsonResponse = '';
      PrescIdInput = pPrescId;
      TakenTsInput = pTakenTs;

      // Insert dose record
      Exec SQL
        Insert Into PILLTRK.DOSE_HIST
          (PRESC_ID, TAKEN_TS)
        Values
          (:PrescIdInput, :TakenTsInput);

      If SQLCODE = 0;
        // Get the generated dose ID
        Exec SQL
          Select DOSE_ID
          Into :NewDoseId
          From PILLTRK.DOSE_HIST
          Where PRESC_ID = :PrescIdInput
            And TAKEN_TS = :TakenTsInput
          Order By DOSE_ID Desc
          Fetch First 1 Row Only;

        If SQLCODE = 0;
          // Build success JSON response
          JsonResponse = '{';
          JsonResponse += '"id":' + %Char(NewDoseId) + ',';
          JsonResponse += '"prescription_id":' + %Char(PrescIdInput) + ',';
          JsonResponse += '"taken_at":"' + %Char(TakenTsInput) + '"';
          JsonResponse += '}';
          ResponseCode = 201;
        Else;
          JsonResponse = '{"error":"Error retrieving created dose"}';
          ResponseCode = 500;
        EndIf;
      Else;
        JsonResponse = '{"error":"Error inserting dose record"}';
        ResponseCode = 500;
      EndIf;

      // Return response
      pResponse = JsonResponse;
      pRespCode = ResponseCode;

      *InLR = *On;
      Return;