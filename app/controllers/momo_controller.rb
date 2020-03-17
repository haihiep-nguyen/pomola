class MomoController < ApplicationController
  protect_from_forgery with: :null_session

  def ipn
    puts 'momo ipn'
    puts 'momo here'
    raise params.inspect
  end

  def return_url
    puts 'return url here'
    raise params.inspect
  end

  def send_to_momo
    #parameters send to MoMo get get payUrl
    endpoint = "https://test-payment.momo.vn/gw_payment/transactionProcessor";
    partnerCode = "MOMOBKUN20180529"
    accessKey = "klm05TvNBzhg7h7j"
    serectkey = "at67qH6mk8w5Y1nAyMoYKMWACiEi2bsa"
    orderInfo = "Thanh toán qua MoMo"
    returnUrl = momo_return_url_url
    notifyurl = momo_ipn_url
    amount = "50000"
    orderId = "cart-123#{Time.zone.now.to_i}"
    requestId = Time.zone.now.to_i.to_s
    requestType = "captureMoMoWallet"
    extraData = "merchantName=MoMo Partner" #pass empty value if your merchant does not have stores else merchantName=[storeName]; merchantId=[storeId] to identify a transaction map with a physical store

    #before sign HMAC SHA256 with format
    #partnerCode=$partnerCode&accessKey=$accessKey&requestId=$requestId&amount=$amount&orderId=$oderId&orderInfo=$orderInfo&returnUrl=$returnUrl&notifyUrl=$notifyUrl&extraData=$extraData
    rawSignature = "partnerCode="+partnerCode.to_s+"&accessKey="+accessKey.to_s+"&requestId="+requestId.to_s+"&amount="+amount.to_s+"&orderId="+orderId.to_s+"&orderInfo="+orderInfo.to_s+"&returnUrl="+returnUrl.to_s+"&notifyUrl="+notifyurl.to_s+"&extraData="+extraData.to_s
    #puts raw signature
    puts "--------------------RAW SIGNATURE----------------"
    puts rawSignature
    #signature
    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), serectkey, rawSignature)
    puts "--------------------SIGNATURE----------------"
    puts signature
    rawSignatureToGet = "partnerCode=#{partnerCode.to_s}&accessKey=#{accessKey}&requestId=#{requestId.to_s}&orderId=#{orderId.to_s}&requestType=transactionStatus"
    signatureToGet = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), serectkey, rawSignatureToGet)
    puts "--------------------SIGNATURE TO GET----------------"
    puts rawSignatureToGet
    puts signatureToGet
    #json object send to MoMo endpoint
    jsonRequestToMomo = {
        :partnerCode => partnerCode,
        :accessKey => accessKey,
        :requestId => requestId,
        :amount => amount,
        :orderId => orderId,
        :orderInfo => orderInfo,
        :returnUrl => returnUrl,
        :notifyUrl => notifyurl,
        :extraData => extraData,
        :requestType => requestType,
        :signature => signature,
    }
    puts "--------------------JSON REQUEST----------------"
    puts JSON.pretty_generate(jsonRequestToMomo)
    # Create the HTTP objects
    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.path)
    request.add_field('Content-Type', 'application/json')
    request.body = jsonRequestToMomo.to_json


    # Send the request and get the response
    puts "SENDING...."
    response = http.request(request)
    result = JSON.parse(response.body)
    puts "--------------------RESPONSE----------------"
    puts JSON.pretty_generate(result)
    puts "pay URL is: " + result["payUrl"]
    raise result.inspect
  end
end