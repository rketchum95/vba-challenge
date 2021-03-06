Attribute VB_Name = "Module1"
Sub stockprices()

Dim ws_count As Integer
Dim j As Integer

ws_count = ActiveWorkbook.Worksheets.Count
For j = 1 To ws_count
ThisWorkbook.Worksheets(j).Activate

Dim ticker_name As String
Dim open_amount As Double
Dim close_amount As Double
Dim total_stock_volume As Double
Dim stocksummary_table_row As Long

'begin entries at 2
stocksummary_table_row = 2
total_stock_volume = 0
open_amount = Cells(2, 3).Value
last_row = Cells(Rows.Count, 1).End(xlUp).Row
Range("L:L").FormatConditions.Delete


'***********************SUMMARY TABLE******************************
'stock summmary table headers'
Cells(1, 11).Value = "Ticker"
Cells(1, 12).Value = "Yearly Change"
Cells(1, 13).Value = "Percent Change"
Cells(1, 14).Value = "Total Stock Volume"

'summary table formatting
Range("M:M").NumberFormat = "0.00%"
Range("L:L").FormatConditions.Add Type:=xlCellValue, Operator:=xlGreater, Formula1:="=0"
    Range("L:L").FormatConditions(1).Interior.ColorIndex = 4
Range("L:L").FormatConditions.Add Type:=xlCellValue, Operator:=xlLess, Formula1:="=0"
    Range("L:L").FormatConditions(2).Interior.ColorIndex = 3
Cells(1, 12).FormatConditions.Delete

 
'begin for loop process within each worksheet
    For I = 2 To last_row
                
    'checking for new ticker value'
        If Cells(I, 1).Value <> Cells(I + 1, 1).Value Then
            
        'defining variables'
            close_amount = Cells(I, 6).Value
            total_stock_volume = total_stock_volume + Cells(I, 7).Value
            ticker_name = Cells(I, 1).Value
            
        'fill in summary table'
            Cells(stocksummary_table_row, 11).Value = ticker_name
            Cells(stocksummary_table_row, 14).Value = total_stock_volume
            
            yearly_change = close_amount - open_amount
                If open_amount = 0 Then
                    percent_change = 0
                Else
                    percent_change = yearly_change / open_amount
                End If
            
            Cells(stocksummary_table_row, 12).Value = yearly_change
            Cells(stocksummary_table_row, 13).Value = percent_change
            
        'reset variables'
            total_stock_volume = 0
            open_amount = Cells(I + 1, 3).Value
                        
        'move to new line in summary table'
            stocksummary_table_row = stocksummary_table_row + 1
         
        Else
            Cells(I, 1).Value = Cells(I + 1, 1).Value
            total_stock_volume = total_stock_volume + Cells(I, 7).Value

        End If

    Next I

'Format columns - completing early caused slowness'
Range("K1:N1").Columns.AutoFit

'*****************BONUS WORK***********************
'KPI Table Setup
Cells(2, 16).Value = "Greatest % Increase"
Cells(3, 16).Value = "Greatest % Decrease"
Cells(4, 16).Value = "Greatest Total Volume"
Cells(1, 17).Value = "Ticker"
Cells(1, 18).Value = "Value"


Dim Max_Percent As Double
Dim Min_Percent As Double
Dim Max_Volume As Double


Max_Percent = Application.WorksheetFunction.Max(Range("M:M"))
Min_Percent = Application.WorksheetFunction.Min(Range("M:M"))
Max_Volume = Application.WorksheetFunction.Max(Range("N:N"))


'Complete KPI Table Values
   
Cells(2, 18).Value = Max_Percent
Cells(2, 17).Value = Application.WorksheetFunction.XLookup(Max_Percent, Range("M:M"), Range("K:K"))

Cells(3, 18).Value = Min_Percent
Cells(3, 17).Value = Application.WorksheetFunction.XLookup(Min_Percent, Range("M:M"), Range("K:K"))

Cells(4, 18).Value = Max_Volume
Cells(4, 17).Value = Application.WorksheetFunction.XLookup(Max_Volume, Range("N:N"), Range("K:K"))


'KPI Table formatting

Range("R2:R3").NumberFormat = "0.00%"

Columns("P:P").ColumnWidth = 20
Columns("Q:Q").ColumnWidth = 10
Columns("R:R").ColumnWidth = 15

'Complete workbook loop
Next j


End Sub



        


