unit TapDisplayTypes;

interface
type
  TWaveDirection = (wdDown = -1, wdStraight = 0, wdUp = 1);
  TSearchPhase = (spMinimum = -1, spInitial = 0, spMaximum = 1);

  TSample = record
    Value: Integer;
    Position: Integer;
  end;
  TSampleDynArray = array of TSample;
  PTrigger = ^TTrigger;
  TTrigger = record
    Length: Integer;
    TAPValue: Integer;
    Position: Integer;
  end;
  TTriggerBuffer = array of TTrigger;

  TSampleState = record
    Sample: TSample;
    PrevSample: TSample;
    Direction: TWaveDirection;
    PrevDirection: TWaveDirection;
    Minimum: TSample;
    Maximum: TSample;
    PrevTrigger: TSample;
    SearchPhase: TSearchPhase;
  end;

  TEndianness = (LSbF, MSbF);

const
  C64_FREQUENCY = 985248;
  MAX_TRIGGER_LENGTH = $00FFFFFF;
  PAUSE_MIN_TRIGGER_LENGTH = $800;
  PAUSE_DEFAULT_TRIGGER_LENGTH = C64_FREQUENCY div 10; // 100 ms

implementation

end.
