class ActiveRecord::Base

  # 配列でエラーメッセージが格納されていることにより
  # vue/cli側で取得することが困難になっているため
  # 配列の先頭のメッセージを取得する
  def extraction_error_message
    error_messages = {}
    errors.each{|key, value|
        error_messages[key] = value
    }
    error_messages
  end
end