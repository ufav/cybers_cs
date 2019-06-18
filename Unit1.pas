unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdHTTP, Vcl.StdCtrls, IdBaseComponent,
  IdAntiFreezeBase, IdAntiFreeze, RegExpr;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    IdAntiFreeze1: TIdAntiFreeze;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.WindowState := wsMaximized;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  re1: TRegExpr;
  lst1, lst2, lst3: TStringList;
  s, t: string;
  i, j, k, pi: Integer;
  team1, team2, score1, score2, map1, map2, map3, map11, map12, map21, map22, map31, map32, team1m, team2m, datetime, contest, bestof, matches, h2h, last61, last62: string;

begin
  IdHTTP := TIdHTTP.Create;
  IdHTTP.HandleRedirects := True;
  IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';
  lst1 := TStringList.Create;
  re1 := TRegExpr.Create;

  s := IdHTTP.Get('https://www.cybersport.ru/base/match?disciplines=19&page=1&status=past&date-from=' + Edit1.Text + '&date-to=' + Edit2.Text);
  t := Copy(s, Pos('Пагинация', s), Pos('/Пагинация', s) - Pos('Пагинация', s));  //pages count
  if Pos('__item', t) > 0 then
    begin
      re1.Expression := '__item">(.*?)</a>';
      if re1.Exec(t) then
        repeat
          lst1.Add(re1.Match[1])
        until not re1.ExecNext;
      pi := StrToInt(lst1.Strings[lst1.Count - 1]);
      lst1.Clear;
    end
  else
    pi := 1;

  re1.Expression := '/base/match(.*?)"';  //events url list
  for i := 1 to pi do
    begin
      s := IdHTTP.Get('https://www.cybersport.ru/base/match?disciplines=19&page=' + IntToStr(i) + '&status=past&date-from=' + Edit1.Text + '&date-to=' + Edit2.Text);
      s := Copy(s, Pos('>Матч<', s), Pos('Пагинация', s) - Pos('>Матч<', s));
      if re1.Exec(s) then
        repeat
          lst1.Add(re1.Match[1])
        until not re1.ExecNext;
    end;
  //Memo1.Text := lst1.Text;

  lst2 := TStringList.Create;
  s := IdHTTP.Get('https://www.cybersport.ru/base/match' + lst1.Strings[0]);

  re1.Expression := 'duel__title">(.*?)</h2>';  //teams
  if re1.Exec(s) then
    repeat
      lst2.Add(re1.Match[1])
    until not re1.ExecNext;
  team1 := lst2.Strings[0];
  team2 := lst2.Strings[1];
  Memo1.Text := lst2.Text;
  lst2.Clear;

  t := Copy(s, Pos('duel__count-score', s), Pos('duel__logo', s) - Pos('duel__count-score', s));
  re1.Expression := '<span>(.*?)</span>';  //scores
  if re1.Exec(t) then
    repeat
      lst2.Add(re1.Match[1])
    until not re1.ExecNext;
  score1 := lst2.Strings[0];
  score2 := lst2.Strings[1];
  Memo1.Lines.Add(lst2.Text);
  lst2.Clear;

  t := Copy(s, Pos('duel__score-maps', s), Pos('duel__meeting', s) - Pos('duel__score-maps', s));
  re1.Expression := '@(.*?)</span>';  //maps
  if re1.Exec(t) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  map1 := lst2.Strings[0];
  if lst2.Count > 1 then map2 := lst2.Strings[1];
  if lst2.Count > 2 then map3 := lst2.Strings[2];
  Memo1.Lines.Add(lst2.Text);
  lst2.Clear;

  re1.Expression := '<strong>(.*?):';  //map scores 1
  if re1.Exec(t) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  map11 := lst2.Strings[0];
  if lst2.Count > 1 then map21 := lst2.Strings[1];
  if lst2.Count > 2 then map31 := lst2.Strings[2];
  Memo1.Lines.Add(lst2.Text);
  lst2.Clear;

  re1.Expression := ':(.*?)</strong';  //map scores 2
  if re1.Exec(t) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  map12 := lst2.Strings[0];
  if lst2.Count > 1 then map22 := lst2.Strings[1];
  if lst2.Count > 1 then map32 := lst2.Strings[2];
  Memo1.Lines.Add(lst2.Text);
  lst2.Clear;

  t := Copy(s, Pos('duel__gamers', s) + 1, Pos('duel__score-maps', s) - Pos('duel__gamers', s));
  team1m := Copy(t, Pos('unstyled', t), Pos('duel__gamers', t) - Pos('unstyled', t));
  re1.Expression := '</i>(.*?)<span>';  //team 1 members
  if re1.Exec(team1m) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  lst2.Delimiter := '|';
  lst2.QuoteChar := #0;
  team1m := lst2.DelimitedText;
  Memo1.Lines.Add(team1m);
  lst2.Clear;

  team2m := Copy(t, Pos('duel__gamers', t), length(t) - Pos('duel__gamers', t));
  re1.Expression := '</i>(.*?)<span>';  //team 2 members
  if re1.Exec(team2m) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  lst2.Delimiter := '|';
  lst2.QuoteChar := #0;
  team2m := lst2.DelimitedText;
  Memo1.Lines.Add(team2m);
  lst2.Clear;  

  datetime := Copy(s, Pos('duel__score', s), Pos('duel__spoiler', s) - Pos('duel__score', s));
  re1.Expression := 'datetime="(.*?)">';  //event date
  re1.Exec(datetime);
  datetime := re1.Match[1];
  Memo1.Lines.Add(datetime);

  contest := Copy(s, Pos('duel__wrapper', s), Pos('duel__inner', s) - Pos('duel__wrapper', s));
  re1.Expression := 'revers">(.*?)</a>';  //contest
  re1.Exec(contest);
  contest := Trim(StringReplace(re1.Match[1], 'CS:GO | ', '', [rfIgnoreCase, rfReplaceAll]));
  Memo1.Lines.Add(contest);

  bestof := Copy(s, Pos('duel__score-maps', s), Pos('duel__meeting', s) - Pos('duel__score-maps', s));
  re1.Expression := '<h4>(.*?)</h4>';  //best of
  re1.Exec(bestof);
  bestof := re1.Match[1];
  Memo1.Lines.Add(bestof);

  re1.Expression := 'История встреч:(.*?)</p>';  //matches
  re1.Exec(s);
  matches := Trim(re1.Match[1]);
  Memo1.Lines.Add(matches);

  h2h := Copy(s, Pos('duel__points', s), Pos('js-mediator-article', s) - Pos('duel__points', s));
  re1.Expression := '\((.*?)\)';  //h2h
  if re1.Exec(h2h) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  lst2.Delimiter := '-';
  lst2.QuoteChar := #0;
  h2h := lst2.DelimitedText;    
  Memo1.Lines.Add(h2h);
  lst2.Clear;

  t := Copy(s, Pos('>История встреч<', s), Pos('page__comments', s) - Pos('>История встреч<', s) + 15);
  t := Copy(t, Pos('class="matches">', t) + 1, Pos('page__comments', t) - Pos('class="matches">', t));
  last61 := Copy(t, Pos('lass="matches">', t), Pos('class="matches">', t) - Pos('lass="matches">', t));
  //last62 := Copy(t, Pos('class="matches">', t), length(t) - Pos('class="matches">', t));
  re1.Expression := 'team--left(.*?)</a>';  //last61
  if re1.Exec(last61) then
    repeat
      lst2.Add(Trim(re1.Match[1]))
    until not re1.ExecNext;
  //Memo1.Lines.Add(lst2.Text);
  Memo1.Lines.Add(last61);
  
  
end;

end.
