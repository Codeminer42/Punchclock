def suffle_otp(otp)
  new_otp = otp.chars.shuffle.join

  if new_otp == otp
    suffle_otp(new_otp)
  else
    new_otp
  end
end
