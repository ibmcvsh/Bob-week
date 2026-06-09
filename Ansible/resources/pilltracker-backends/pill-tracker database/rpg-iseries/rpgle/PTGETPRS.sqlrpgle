      **FREE
      //*****************************************************************
      //* PTGETPRS - Get Prescriptions with History
      //* Description: RPG ILE program to retrieve prescriptions for a
      //*              user with last dose information via REST API
      //* Author: System Generated
      //* Date: 2026-03-05
      //*****************************************************************

      Ctl-Opt DftActGrp(*No) ActGrp(*Caller) BndDir('QC2LE');

      //*****************************************************************
      //* Prototypes
      //*****************************************************************
      Dcl-PR BuildJsonPrescriptions Varchar(32000);
      End-PR;

      //*****************************************************************
      //* Includes
      //*****************************************************************
      /Copy PILLTRK/QRPGLEREF,PRESCSTR

      //*****************************************************************
      //* Global Variables
      //*****************************************************************
      Dcl-S JsonResponse Varchar(32000);
      Dcl-S ResponseCode Int(10) Inz(200);
      Dcl-S UserIdInput Int(10);
      Dcl-S Idx Int(10);

      //*****************************************************************
      //* SQL Declarations
      //*****************************************************************
      Exec SQL
        Set Option Commit = *None,
                   CloSqlCsr = *EndMod;

      Exec SQL
        Declare PrescCursor Cursor For
        Select P.PRESC_ID,
               P.USER_ID,
               P.PRESC_NAME,
               P.PRESC_DESC,
               P.FREQ_HOURS,
               P.CREATED_TS,
               D.TAKEN_TS
        From PILLTRK.PRESCRIP P
        Left Join Lateral (
          Select TAKEN_TS
          From PILLTRK.DOSE_HIST
          Where PRESC_ID = P.PRESC_ID
          Order By TAKEN_TS Desc
          Fetch First 1 Row Only
        ) D On 1=1
        Where P.USER_ID = :UserIdInput
        Order By P.PRESC_ID;

      //*****************************************************************
      //* Main Procedure
      //*****************************************************************
      Dcl-PI *N;
        pUserId Int(10) Const;
        pResponse Char(32000);
        pRespCode Int(10);
      End-PI;

      // Initialize
      PrescCount = 0;
      JsonResponse = '';
      UserIdInput = pUserId;

      // Fetch all prescriptions for user
      Exec SQL
        Open PrescCursor;

      If SQLCODE = 0;
        DoU SQLCODE <> 0;
          Exec SQL
            Fetch Next From PrescCursor
            Into :PrescRec.PrescId,
                 :PrescRec.UserId,
                 :PrescRec.PrescName,
                 :PrescRec.PrescDesc,
                 :PrescRec.FreqHours,
                 :PrescRec.CreatedTs,
                 :PrescRec.LastTakenTs;

          If SQLCODE = 0;
            PrescCount += 1;
            PrescArray(PrescCount) = PrescRec;
          EndIf;
        EndDo;

        Exec SQL
          Close PrescCursor;

        // Build JSON response
        JsonResponse = BuildJsonPrescriptions();
        ResponseCode = 200;
      Else;
        JsonResponse = '{"error":"Database error fetching prescriptions"}';
        ResponseCode = 500;
      EndIf;

      // Return response
      pResponse = JsonResponse;
      pRespCode = ResponseCode;

      *InLR = *On;
      Return;

      //*****************************************************************
      //* BuildJsonPrescriptions - Build JSON array of prescriptions
      //*****************************************************************
      Dcl-Proc BuildJsonPrescriptions;
        Dcl-PI *N Varchar(32000);
        End-PI;

        Dcl-S Json Varchar(32000);
        Dcl-S TempStr Varchar(1000);
        Dcl-S i Int(10);

        // Start JSON array
        Json = '[';

        // Loop through prescriptions
        For i = 1 To PrescCount;
          If i > 1;
            Json += ',';
          EndIf;

          // Build prescription object
          Json += '{';
          Json += '"id":' + %Char(PrescArray(i).PrescId) + ',';
          Json += '"user_id":' + %Char(PrescArray(i).UserId) + ',';
          Json += '"name":"' + %Trim(PrescArray(i).PrescName) + '",';
          Json += '"description":"' + %Trim(PrescArray(i).PrescDesc) + '",';
          Json += '"frequency_hours":' + %Char(PrescArray(i).FreqHours) + ',';

          // Add last_taken timestamp or null
          If PrescArray(i).LastTakenTs <> *Loval;
            TempStr = %Char(PrescArray(i).LastTakenTs);
            Json += '"last_taken":"' + %Trim(TempStr) + '"';
          Else;
            Json += '"last_taken":null';
          EndIf;

          Json += '}';
        EndFor;

        // Close JSON array
        Json += ']';

        Return Json;
      End-Proc;