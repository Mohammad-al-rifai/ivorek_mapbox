class Validations {
  static bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool isPassword(String password) {
    /**
     * This means that the password must contain one digit from 1 to 9,
     * one lowercase letter,
     * one uppercase letter,
     * one special character,
     * no space, and it must be 8-16 characters long
     */
    return password.length >= 8;
    // ‼RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
    //     .hasMatch(password);
  }

  static bool isPhoneNum(String number) {
    return number.length >= 10 && number.length <= 15;
  }

  static bool isOTPValid(String otp) {
    return otp.length >= 5 && otp.length <= 10;
  }
}
