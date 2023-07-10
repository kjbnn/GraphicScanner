unit mScanner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type

  mValue = record
    Value : byte;
    Color : dword;
    end;

  TScanner = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  private
  public
    StartFlag : byte;
    FonColor : dword;
    Pos : word;
    Col, Row : word;
    kx, ky : real;
    tw, th : word;
    m_buf : array of mValue;
    procedure Init(mLeft, mTop, mCol, mRow: word);
    procedure Draw(m: array of byte; Num: word; Color: dword);

  end;

var
  Scanner: TScanner;

implementation

{$R *.DFM}

//-------------------------------------------------------------------------
procedure TScanner.Init(mLeft, mTop, mCol, mRow: word);
var
 i: word;
begin
 StartFlag:= 0;
 FonColor:= clGray;
 Col:= mCol;
 Row:= mRow;
 kx:= 1.2;
 ky:= 1.2;
 tw:= round(kx*Canvas.TextWidth ('DD'));
 th:= round(ky*Canvas.TextHeight('DD'));
 ClientWidth:= round(Col*tw*1.00);
 ClientHeight:= round(Row*th*1.00);
 SetLength(m_buf,Col*Row);
 for i:=0 to Col*mRow-1 do
   m_buf[i].Color:=FonColor;
 Pos:=0;
 self.Left:= mLeft;
 self.Top:= mTop;
end;

//-------------------------------------------------------------------------
procedure TScanner.Draw(m: array of byte; Num: word; Color: dword);
var
 i : word;

begin
 if Num=0 then
   exit;

 for i:=0 to Num-1 do
 begin
   inc(Pos);
   if Pos>(Col*Row) then begin Pos:=1; StartFlag:=1; end;
   m_buf[Pos-1].Value:= m[i];
   m_buf[Pos-1].Color:= Color;
   Canvas.Brush.Color:= m_buf[Pos-1].Color;
   Canvas.FillRect(Rect(2+((Pos-1) mod Col)*tw,2+((Pos-1) div Col)*th,2+((Pos-1) mod Col)*tw+16,2+((Pos-1) div Col)*th+13));
   Canvas.TextOut(2+((Pos-1) mod Col)*tw, 2+((Pos-1) div Col)*th, inttohex(m_buf[Pos-1].Value,2));
 end;

 Canvas.Brush.Color:= clBlack;
 Canvas.FillRect(Rect(2+((Pos) mod Col)*tw,2+((Pos) div Col)*th,2+((Pos) mod Col)*tw+16,2+((Pos) div Col)*th+13));
end;

//-------------------------------------------------------------------------
procedure TScanner.FormPaint(Sender: TObject);
var
 i: word;

begin
 Canvas.Brush.Color:= FonColor;
 Canvas.Rectangle(0,0,ClientWidth,ClientHeight);

 case StartFlag of
  0:
    if Pos>0 then
     for i:=0 to Pos-1 do
      begin
       Canvas.Brush.Color:= m_buf[i].Color;
       Canvas.FillRect(Rect(2+(i mod Col)*tw,2+(i div Col)*th,2+(i mod Col)*tw+16,2+(i div Col)*th+13));
       Canvas.TextOut(2+(i mod Col)*tw, 2+(i div Col)*th, inttohex(m_buf[i].Value,2));
      end;

  1:
    for i:=0 to Col*Row-1 do
     begin
      Canvas.Brush.Color:= m_buf[i].Color;
      Canvas.FillRect(Rect(2+(i mod Col)*tw,2+(i div Col)*th,2+(i mod Col)*tw+16,2+(i div Col)*th+13));
      Canvas.TextOut(2+(i mod Col)*tw, 2+(i div Col)*th, inttohex(m_buf[i].Value,2));
     end;
  end; //case StartFlag of


 Canvas.Brush.Color:= clBlack;
 Canvas.FillRect(Rect(2+((Pos) mod Col)*tw,2+((Pos) div Col)*th,2+((Pos) mod Col)*tw+15,2+((Pos) div Col)*th+13));
end;

//-------------------------------------------------------------------------
procedure TScanner.FormDblClick(Sender: TObject);
begin
 Init(Left, Top, Col, Row);
 Canvas.Brush.Color:= clGray;
 Canvas.FillRect(Canvas.ClipRect);
end;



end.
