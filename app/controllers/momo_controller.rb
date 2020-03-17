class MomoController < ApplicationController
  protect_from_forgery with: :null_session

  def show
    raise 'in show controller'
    raise params.inspect
    raise 'show'
  end

  def ipn
    puts 'momo ipn'
    puts 'momo here'
    raise params.inspect
  end

  def return_url
    puts 'return url here'
    raise params.inspect
  end

  def send_to_vnpay
    vnp_url = "http://sandbox.vnpayment.vn/paymentv2/vpcpay.html"
    vnp_returnurl = momo_handle_ipn_url
    vnp_txn_ref = "#{1}-#{Time.zone.now.to_i}"
    vnp_order_info = "thanh toan gio hang #{1}"
    vnp_order_type = '1'
    vnp_amount = (10000 * 100)
    vnp_locale = I18n.locale.to_s
    vnp_ip_address = request.remote_ip
    vnp_tmn_code = 'MOZWGVE8'
    vnp_hash_secret = 'XQGBPUZANBSIGZNKCLLWBEHETPPPQTUW'
    vnp_command = 'pay'

    input_data = {
        "vnp_Amount" => vnp_amount,
        "vnp_Command" => vnp_command,
        "vnp_CreateDate" => Time.zone.now.strftime('%Y%m%d%H%M%S'),
        "vnp_CurrCode" => "VND",
        "vnp_Locale" => 'vn',
        "vnp_IpAddr" => vnp_ip_address,
        "vnp_OrderInfo" => vnp_order_info,
        "vnp_OrderType" => vnp_order_type,
        "vnp_ReturnUrl" => vnp_returnurl,
        "vnp_TmnCode" => vnp_tmn_code,
        "vnp_TxnRef" => vnp_txn_ref,
        "vnp_Version" => "2.0.0",
    }

    # this is bank code if customer choose bank before redirect
    # input_data.store("vnp_bank_code", vnp_bank_code) if vnp_bank_code.present?
    i = 0
    hash_data = ''
    query = ''

    input_data = input_data.sort_by{|k, v| k.downcase}.to_h
    input_data.each do |k, v|
      if i == 1
        hash_data += "&#{k}=#{v}"
      elsif i == 0
        hash_data += "#{k}=#{v}"
        i = 1
      end
      query += "#{k}=#{v}&"
    end

    vnp_url += "?#{query}"
    if vnp_hash_secret.present?
      require 'digest'
      vnp_secure_hash = Digest::SHA256.hexdigest vnp_hash_secret + hash_data
      vnp_url += "vnp_SecureHashType=SHA256&vnp_SecureHash=#{vnp_secure_hash}"
    end
    redirect_to vnp_url
  end

  def handle_ipn
    puts 'in handle vnpay'
    raise params.inspect
    vnpHashSecret = 'XQGBPUZANBSIGZNKCLLWBEHETPPPQTUW'
    inputData = {}
    returnData = {}
    data = params
    data.each do |key, value|
      if key[0..3] == "vnp_"
        inputData[key] = value
      end
    end
    vnp_SecureHash = inputData['vnp_SecureHash']
    inputData.delete('vnp_SecureHashType')
    inputData.delete('vnp_SecureHash')
    inputData = inputData.sort_by{|k, v| k.downcase}.to_h
    i = 0
    hashData = ""
    inputData.each do |key, value|
      if i == 1
        hashData = "#{hashData}&#{key}=#{value}"
      else
        hashData = "#{hashData}#{key}=#{value}"
        i = 1
      end
    end

    vnpTranId = inputData['vnp_TransactionNo'] #Mã giao dịch tại VNPAY
    vnp_BankCode = inputData['vnp_BankCode'] #Ngân hàng thanh toán
    #$secureHash = md5($vnp_HashSecret . $hashData);
    secureHash = Digest::SHA256.hexdigest vnpHashSecret + hashData
    status = 0
    orderId = inputData['vnp_TxnRef']
    begin
      #Check Orderid
      #Kiểm tra checksum của dữ liệu
      if secureHash == vnp_SecureHash
        #Lấy thông tin đơn hàng lưu trong Database và kiểm tra trạng thái của đơn hàng, mã đơn hàng là: $orderId
        #Việc kiểm tra trạng thái của đơn hàng giúp hệ thống không xử lý trùng lặp, xử lý nhiều lần một giao dịch
        #Giả sử: $order = mysqli_fetch_assoc($result);
        order = NULL
        if order != NULL
          if order["Status"] != NULL && order["Status"] == 0
            if inputData['vnp_ResponseCode'] == '00'
              status = 1
            else
              status = 2
            end
            #Trả kết quả về cho VNPAY: Website TMĐT ghi nhận yêu cầu thành công
            returnData['RspCode'] = '00'
            returnData['Message'] = 'Confirm Success'
          else
            returnData['RspCode'] = '02'
            returnData['Message'] = 'Order already confirmed'
          end
        else
          returnData['RspCode'] = '01'
          returnData['Message'] = 'Order not found'
        end
      else
        returnData['RspCode'] = '97'
        returnData['Message'] = 'Chu ky khong hop le'
      end
    rescue
      returnData['RspCode'] = '99'
      returnData['Message'] = 'Unknow error'
    end
    raise returnData.inspect
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