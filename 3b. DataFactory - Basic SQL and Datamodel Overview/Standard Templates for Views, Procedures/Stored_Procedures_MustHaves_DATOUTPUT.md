Sub WetterSpeichern()

'Datei und Pfad sind Wörter, die in VBA
  'Verwendung finden und deshalb verboten
  'sind
  Dim sDatei As String, sZielDatei As String
  Dim Pos
  'Dim sPfad As String
  'hier fehlt der Backslash (\)
  'sPfad = ThisWorkbook.Path
  sPfad = ActiveWorkbook.Path & "\"
  sDatei = ActiveWorkbook.Name
  '
  'in Dateinamen sind z.B. Doppelpunkte
  'nicht erlaubt
  'Dateinamen extrahieren
  Pos = InStrRev(sDatei, ".", , vbTextCompare)
  sZielDatei = sPfad & Mid(sDatei, 1, Pos - 1)
  sZielDatei = sZielDatei _
    & "_" & Format(Date, "yyyyMMdd_") _
    & Format(Time, "hh-mm")
  'MsgBox sZielDatei
  '
  ActiveWorkbook.SaveAs Filename:=sZielDatei & ".csv", _
    FileFormat:=xlCSV, CreateBackup:=False

End Sub
