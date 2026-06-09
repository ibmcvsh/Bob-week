//PTCOMPIL JOB (ACCT),'COMPILE PILL TRACKER',
//         CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1),
//         NOTIFY=&SYSUID
//*
//*****************************************************************
//* JCL TO COMPILE COBOL PROGRAMS FOR PILL TRACKER API
//*****************************************************************
//*
//*****************************************************************
//* STEP 1: COMPILE PTGETURS (GET USERS)
//*****************************************************************
//COMPURS EXEC PROC=DFHYITDL,
//         PROGLIB='PILLTRK.LOADLIB',
//         DSCTLIB='PILLTRK.COPYLIB',
//         INDEX='PILLTRK'
//COMPILE.SYSIN DD *
       CBL CICS,SQL
       COPY PTGETURS FROM PILLTRK.SRCLIB
/*
//*
//*****************************************************************
//* STEP 2: COMPILE PTGETPRS (GET PRESCRIPTIONS)
//*****************************************************************
//COMPPRS EXEC PROC=DFHYITDL,
//         PROGLIB='PILLTRK.LOADLIB',
//         DSCTLIB='PILLTRK.COPYLIB',
//         INDEX='PILLTRK'
//COMPILE.SYSIN DD *
       CBL CICS,SQL
       COPY PTGETPRS FROM PILLTRK.SRCLIB
/*
//*
//*****************************************************************
//* STEP 3: COMPILE PTPOSTDS (POST DOSE)
//*****************************************************************
//COMPPOST EXEC PROC=DFHYITDL,
//         PROGLIB='PILLTRK.LOADLIB',
//         DSCTLIB='PILLTRK.COPYLIB',
//         INDEX='PILLTRK'
//COMPILE.SYSIN DD *
       CBL CICS,SQL
       COPY PTPOSTDS FROM PILLTRK.SRCLIB
/*
//*
//*****************************************************************
//* STEP 4: BIND DB2 PACKAGES
//*****************************************************************
//BIND    EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(DB2P)
  BIND PACKAGE(PILLTRK) -
       MEMBER(PTGETURS) -
       ACTION(REPLACE) -
       ISOLATION(CS) -
       VALIDATE(BIND) -
       RELEASE(COMMIT)
  BIND PACKAGE(PILLTRK) -
       MEMBER(PTGETPRS) -
       ACTION(REPLACE) -
       ISOLATION(CS) -
       VALIDATE(BIND) -
       RELEASE(COMMIT)
  BIND PACKAGE(PILLTRK) -
       MEMBER(PTPOSTDS) -
       ACTION(REPLACE) -
       ISOLATION(CS) -
       VALIDATE(BIND) -
       RELEASE(COMMIT)
  END
/*