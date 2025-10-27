	       IDENTIFICATION DIVISION.
	       PROGRAM-ID. OLAMUNDO.
	       AUTHOR. GersonESantos.
	       DATE-WRITTEN. 26/10/2025.

	       ENVIRONMENT DIVISION.
	       INPUT-OUTPUT SECTION.
	       FILE-CONTROL.
	           SELECT OUTFILE ASSIGN TO "out.txt"
	               ORGANIZATION IS LINE SEQUENTIAL.

	       DATA DIVISION.
	       FILE SECTION.
	       FD OUTFILE.
	       01 OUT-REC PIC X(132).

	       WORKING-STORAGE SECTION.
	       01 WS-LINE PIC X(132) VALUE SPACES.

	       PROCEDURE DIVISION.
	           *> Diagnóstico por escrita direta em arquivo (garante saída observável)
	           MOVE "Olá, mundo!" TO WS-LINE
	           OPEN OUTPUT OUTFILE
	           MOVE WS-LINE TO OUT-REC
	           WRITE OUT-REC
	           CLOSE OUTFILE
	           DISPLAY "Escrito em out.txt" UPON CONSOLE.
	           STOP RUN.
