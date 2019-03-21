inherited QueryProductsBase: TQueryProductsBase
  Width = 176
  Height = 81
  ExplicitWidth = 176
  ExplicitHeight = 81
  inherited Label1: TLabel
    Width = 128
    Caption = 'ProductsBaseQuery'
    ExplicitWidth = 128
  end
  inherited FDQuery: TFDQuery
    OnCalcFields = FDQueryCalcFields
    Left = 17
  end
end
