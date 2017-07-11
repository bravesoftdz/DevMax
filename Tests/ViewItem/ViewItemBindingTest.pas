unit ViewItemBindingTest;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestViewItemBinding = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    // Binding Value

    // Binding Field

    // Binding List
  end;

implementation

procedure TTestViewItemBinding.Setup;
begin
end;

procedure TTestViewItemBinding.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestViewItemBinding);
end.
