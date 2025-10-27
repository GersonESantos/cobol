       IDENTIFICATION DIVISION.
       PROGRAM-ID. OLAMUNDO.
       AUTHOR. GersonESantos.
       DATE-WRITTEN. 26/10/2024.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-DUMMY PIC X.

       PROCEDURE DIVISION.
           DISPLAY "DEBUG: Programa iniciado.".
           DISPLAY "Olá, mundo!".
           DISPLAY "DEBUG: Pressione Enter para sair.".
           ACCEPT WS-DUMMY.
           DISPLAY "DEBUG: Programa finalizado.".
           STOP RUN.
