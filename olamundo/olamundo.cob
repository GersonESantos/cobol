	       IDENTIFICATION DIVISION.
	       PROGRAM-ID. OLAMUNDO.
	       AUTHOR. GersonESantos.
	       DATE-WRITTEN. 26/10/2025.

	       ENVIRONMENT DIVISION.

	       DATA DIVISION.
	       WORKING-STORAGE SECTION.
	       01 WS-DUMMY PIC X.

	       PROCEDURE DIVISION.
	           DISPLAY "Olá, mundo!".
	           *> Pausa o programa para garantir que a saída seja visível
	           ACCEPT WS-DUMMY.
	           STOP RUN.
