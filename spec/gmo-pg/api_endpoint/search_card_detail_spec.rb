require 'spec_helper'

RSpec.describe GMO::PG::SearchCardDetail, type: :api_endpoint do
  it_behaves_like 'an API Endpoint', '/payment/SearchCardDetail.idPass'
end

RSpec.describe GMO::PG::SearchCardDetail::Request, type: :request do
  it_behaves_like 'a Payload', :ShopID,   :shop_id
  it_behaves_like 'a Payload', :ShopPass, :shop_pass
  it_behaves_like 'a Payload', :CardNo,   :card_no
  it_behaves_like 'a Payload', :OrderID,  :order_id
  it_behaves_like 'a Payload', :SiteID,   :site_id
  it_behaves_like 'a Payload', :SitePass, :site_pass
  it_behaves_like 'a Payload', :MemberID, :member_id
  it_behaves_like 'a Payload', :SeqMode,  :seq_mode
  it_behaves_like 'a Payload', :CardSeq,  :card_seq

  it_behaves_like 'a typecastable parameter', :CardSeq, GMO::PG::Payload::TypecastableInteger

  it_behaves_like 'a Request'
end

RSpec.describe GMO::PG::SearchCardDetail::Response, type: :response do
  it_behaves_like 'a Payload', :CardNo,                 :card_no
  it_behaves_like 'a Payload', :Brand,                  :brand
  it_behaves_like 'a Payload', :DomesticFlag,           :domestic_flag
  it_behaves_like 'a Payload', :IssuerCode,             :issuer_code
  it_behaves_like 'a Payload', :DebitPrepaidFlag,       :debit_prepaid_flag
  it_behaves_like 'a Payload', :DebitPrepaidIssuerName, :debit_prepaid_issuer_name
  it_behaves_like 'a Payload', :ForwardFinal,           :forward_final
  it_behaves_like 'a Payload', :ErrCode,                :err_code
  it_behaves_like 'a Payload', :ErrInfo,                :err_info

  it_behaves_like 'a Response'
end
