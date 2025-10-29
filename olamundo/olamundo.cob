       IDENTIFICATION DIVISION.
       PROGRAM-ID. OLAMUNDO.
       AUTHOR. GersonESantos.
       DATE-WRITTEN. 26/10/2024.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-DUMMY PIC X.

       PROCEDURE DIVISION.
           DISPLAY "Olá, mundo!".
           ACCEPT WS-DUMMY.
           DISPLAY " Programa finalizado.".
           STOP RUN.
