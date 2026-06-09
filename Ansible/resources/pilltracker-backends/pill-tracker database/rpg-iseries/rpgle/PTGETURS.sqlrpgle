      **FREE
      //*****************************************************************
      //* PTGETURS - Pill Tracker Get Users REST API
      //* Description: RPG ILE program to retrieve all users via REST API
      //* Author: System Generated
      //* Date: 2026-03-05
      //*****************************************************************

      Ctl-Opt DftActGrp(*No) ActGrp(*Caller) BndDir('QC2LE');

      //*****************************************************************
      //* Prototypes
      //*****************************************************************
      Dcl-PR BuildJsonUsers Varchar(32000);
      End-PR;

      //*****************************************************************
      //* Includes
      //*****************************************************************
      /Copy PILLTRK/QRPGLEREF,USERSTRU

      //*****************************************************************
      //* Global Variables
      //*****************************************************************
      Dcl-S JsonResponse Varchar(32000);
      Dcl-S ResponseCode Int(10) Inz(200);
      Dcl-S Idx Int(10);

      //*****************************************************************
      //* SQL Declarations
      //*****************************************************************
      Exec SQL
        Set Option Commit = *None,
                   CloSqlCsr = *EndMod;

      Exec SQL
        Declare UserCursor Cursor For
        Select USER_ID, USER_NAME, CREATED_TS
        From PILLTRK.USERS
        Order By USER_ID;

      //*****************************************************************
      //* Main Procedure
      //*****************************************************************
      Dcl-PI *N;
        pRequest Char(32000) Const;
        pResponse Char(32000);
        pRespCode Int(10);
      End-PI;

      // Initialize
      UserCount = 0;
      JsonResponse = '';

      // Fetch all users
      Exec SQL
        Open UserCursor;

      If SQLCODE = 0;
        DoU SQLCODE <> 0;
          Exec SQL
            Fetch Next From UserCursor
            Into :UserRec.UserId,
                 :UserRec.UserName,
                 :UserRec.CreatedTs;

          If SQLCODE = 0;
            UserCount += 1;
            UserArray(UserCount) = UserRec;
          EndIf;
        EndDo;

        Exec SQL
          Close UserCursor;

        // Build JSON response
        JsonResponse = BuildJsonUsers();
        ResponseCode = 200;
      Else;
        JsonResponse = '{"error":"Database error fetching users"}';
        ResponseCode = 500;
      EndIf;

      // Return response
      pResponse = JsonResponse;
      pRespCode = ResponseCode;

      *InLR = *On;
      Return;

      //*****************************************************************
      //* BuildJsonUsers - Build JSON array of users
      //*****************************************************************
      Dcl-Proc BuildJsonUsers;
        Dcl-PI *N Varchar(32000);
        End-PI;

        Dcl-S Json Varchar(32000);
        Dcl-S TempStr Varchar(1000);
        Dcl-S i Int(10);

        // Start JSON array
        Json = '[';

        // Loop through users
        For i = 1 To UserCount;
          If i > 1;
            Json += ',';
          EndIf;

          // Build user object
          Json += '{';
          Json += '"id":' + %Char(UserArray(i).UserId) + ',';
          Json += '"name":"' + %Trim(UserArray(i).UserName) + '",';
          
          // Format timestamp
          TempStr = %Char(UserArray(i).CreatedTs);
          Json += '"created_at":"' + %Trim(TempStr) + '"';
          Json += '}';
        EndFor;

        // Close JSON array
        Json += ']';

        Return Json;
      End-Proc;