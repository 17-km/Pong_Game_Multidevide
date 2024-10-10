unit main;

interface

uses
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  Winapi.Messages,
  {$ENDIF}

  FMX.Objects,

  System.Generics.Collections,
  System.Math,

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Gestures,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TfMain = class(TForm)
    lMain: TLayout;
    pMain: TPanel;
    gmMain: TGestureManager;
    gmPaddle: TGestureManager;
    procedure pMainGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    Width : Double;
    Height : Double;
    MarginsThickness : Double;
    BordersThickness : Double;
    BallSize : Double;
    BackgroundColor : TAlphaColor;
    ElementsColor : TAlphaColor;
    TopBorder: TRectangle;
    BottomBorder: TRectangle;
    Rectangles: TObjectList<TRectangle>;
    Background: TRectangle;
    Paddle: TRectangle;
    procedure CreateNetRectangles;
    procedure CreateBorders;
    procedure CreateBoard;
    procedure ClearBord;
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

const
  NUMBER_OF_RECTANGLES = 18;

procedure TfMain.ClearBord;
begin
  if Assigned(Rectangles) then
  begin
    Rectangles.Free;
    Rectangles := nil;
  end;
  if Assigned(BottomBorder) then
  begin
    BottomBorder.Free;
    BottomBorder := nil;
  end;
  if Assigned(TopBorder) then
  begin
    TopBorder.Free;
    TopBorder := nil;
  end;
  if Assigned(Background) then
  begin
    Background.Free;
    Background := nil;
  end;
end;

procedure TfMain.CreateBoard;
begin
  Background := TRectangle.Create(lMain);
//  lMain.Align := TAlignLayout.Client;
  Background.Parent := lMain;
  Background.Align := TAlignLayout.Client;

  pMain.Width := Background.Width - 4 * MarginsThickness;
  pMain.Height := Background.Height;
  pMain.Position.Y := 0;
  pMain.Position.X := 2 * MarginsThickness;

  Width := Max(Background.Width, Background.Height);
  Height := Min(Background.Width, Background.Height);

  MarginsThickness := Min(Background.Width, Background.Height) * 1.25 / 100;
  BordersThickness := MarginsThickness;
  BallSize := MarginsThickness;

  BackgroundColor := TAlphaColor($FF0F0F0F);
  ElementsColor :=  TAlphaColor($FF00FF00);

  Background.Fill.Color := BackgroundColor;
  Background.Stroke.Kind := TBrushKind.None;
  CreateBorders;
  CreateNetRectangles;
end;

procedure TfMain.CreateBorders;
begin
  TopBorder := TRectangle.Create(Background);
  BottomBorder := TRectangle.Create(Background);

  Background.Fill.Color := BackgroundColor;

  TopBorder.Parent := Background;
  BottomBorder.Parent := Background;

  TopBorder.Fill.Color := ElementsColor;
  BottomBorder.Fill.Color := ElementsColor;

  TopBorder.Stroke.Kind := TBrushKind.None;
  BottomBorder.Stroke.Kind := TBrushKind.None;

  TopBorder.Height := BordersThickness;
  BottomBorder.Height := BordersThickness;

  TopBorder.Width := Width - 2 * MarginsThickness;
  BottomBorder.Width := Width - 2 * MarginsThickness;

  TopBorder.Position.X := MarginsThickness;
  TopBorder.Position.Y := MarginsThickness;
  BottomBorder.Position.X := MarginsThickness;

  BottomBorder.Position.Y := Height - MarginsThickness - BordersThickness;

  //test
  Paddle := TRectangle.Create(Background);
  Paddle.Parent := Background;
  Paddle.Position.X := MarginsThickness;
  Paddle.Position.Y := 5 * MarginsThickness;
  Paddle.Width := MarginsThickness;
  Paddle.Height := 10 * MarginsThickness;
  Paddle.Fill.Color := ElementsColor;
  Paddle.Stroke.Kind := TBrushKind.None;

end;

procedure TfMain.CreateNetRectangles;
var
  i: Integer;
  NewRectangle: TRectangle;
  PositionX : Double;
  PositionY : Double;
  NetRectangleWidth : Double;
  NetRectangleHeight : Double;
begin
  Rectangles := TObjectList<TRectangle>.Create;
  NetRectangleWidth := BordersThickness;
  NetRectangleHeight := (Height - 3 * MarginsThickness - 2 * BordersThickness) / NUMBER_OF_RECTANGLES - MarginsThickness;
  PositionX := Width / 2 - NetRectangleWidth / 2;
  PositionY := 2 * MarginsThickness + BordersThickness;
  for i := 0 to NUMBER_OF_RECTANGLES - 1 do
  begin
    NewRectangle := TRectangle.Create(Background);
    NewRectangle.Parent := Background;
    NewRectangle.Width := NetRectangleWidth;
    NewRectangle.Height := NetRectangleHeight;
    NewRectangle.Fill.Color := ElementsColor;
    NewRectangle.Stroke.Kind := TBrushKind.None;
    NewRectangle.Position.X := PositionX;
    NewRectangle.Position.Y := PositionY;
    PositionY := PositionY + MarginsThickness + NetRectangleHeight;
    Rectangles.Add(NewRectangle);
  end;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
//  CreateBoard;
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  {$IFDEF MSWINDOWS}
  if Key = VK_ESCAPE then
  begin
    if MessageDlg('Czy chcesz zamkn¹æ aplikacjê?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes then
      Application.Terminate;
  end;
  {$ENDIF}
end;

procedure TfMain.FormResize(Sender: TObject);
begin
  ClearBord;
  CreateBoard;
end;

procedure TfMain.pMainGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if (EventInfo.GestureID = sgiLeft) or (EventInfo.GestureID = sgiRight) then
  ShowMessage('gesture')
  else
  ShowMessage('gesture2');
end;

end.
