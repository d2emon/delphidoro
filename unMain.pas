unit unMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Gauges;

type
  TfmMain = class(TForm)
    ggProgress: TGauge;
    tmTimer: TTimer;
    bbWork: TBitBtn;
    bbRest: TBitBtn;
    bbLongRest: TBitBtn;
    lbTime: TLabel;
    lbEstimate: TLabel;
    bbStop: TBitBtn;
    bbAuto: TBitBtn;
    lbAuto: TLabel;
    lbWork: TLabel;
    lbRound: TLabel;
    procedure tmTimerTimer(Sender: TObject);
    procedure bbWorkClick(Sender: TObject);
    procedure bbRestClick(Sender: TObject);
    procedure bbLongRestClick(Sender: TObject);
    procedure bbStopClick(Sender: TObject);
    procedure bbAutoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Auto: Boolean;
    Work: Boolean;
    Turns: Integer;
    Pomodoro: Integer;
    procedure ResetProgress;
    procedure StartWork;
    procedure StartRest(Long: Boolean);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.tmTimerTimer(Sender: TObject);
var
  Estimate: TTimestamp;
begin
  Estimate := DateTimeToTimestamp(Now);

  lbAuto.Visible := Auto;
  if Work then
    lbWork.Caption := 'Работа'
  else
    lbWork.Caption := 'Отдых';

  if Pomodoro > 0 then
  begin
    ggProgress.AddProgress(1);
    Estimate.Time := (Pomodoro - ggProgress.Progress) * 1000;
  end
  else
  begin
    Estimate.Time := 0;
  end;

  if ggProgress.PercentDone >= 100 then
  begin
    Pomodoro := 0;
    Beep;
    tmTimer.Enabled := False;

    if Auto then
    begin
      if Work then
      begin
        if MessageDlg('Помидор завершен?', mtInformation, [mbYes, mbNo], 0) = mrYes then
        begin
          Turns := Turns + 1;
        end
        else
        begin
          Turns := 0;
        end;

        lbRound.Caption := IntToStr(Turns);

        if (Turns mod 4) = 0 then
        begin
          MessageDlg('Хорошая работа', mtInformation, [mbOk], 0);
          StartRest(True);
        end
        else
        begin
          MessageDlg('Пора отдохнуть', mtInformation, [mbOk], 0);
          StartRest(False);
        end;
      end
      else
      begin
        MessageDlg('За работу!', mtInformation, [mbOk], 0);
        StartWork;
      end;
    end;

    tmTimer.Enabled := True;
  end;

  lbTime.Caption := FormatDateTime('tt', Now);
  lbEstimate.Caption := FormatDateTime('tt', TimeStampToDateTime(Estimate));
  fmMain.Caption := lbEstimate.Caption;
end;

procedure TfmMain.bbWorkClick(Sender: TObject);
begin
  StartWork;
end;

procedure TfmMain.ResetProgress;
begin
  ggProgress.Progress := 0;
  ggProgress.MaxValue := Pomodoro;
end;

procedure TfmMain.bbRestClick(Sender: TObject);
begin
  StartRest(False);
end;

procedure TfmMain.bbLongRestClick(Sender: TObject);
begin
  StartRest(True);
end;

procedure TfmMain.bbStopClick(Sender: TObject);
begin
  Pomodoro := 0;
  Work := False;
  ResetProgress;
end;

procedure TfmMain.bbAutoClick(Sender: TObject);
begin
  Auto := not Auto;
  Work := Auto;
  if Work then
    StartWork
  else
    StartRest(False);
end;

procedure TfmMain.StartWork;
begin
  Pomodoro := 25;
  Work := True;
  ResetProgress;
end;

procedure TfmMain.StartRest(Long: Boolean);
begin
  if Long then
    Pomodoro := 25
  else
    Pomodoro := 5;
  Work := False;
  ResetProgress;
end;

end.
