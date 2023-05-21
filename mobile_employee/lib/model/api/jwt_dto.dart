class JwtDTO {
  String accessToken;
  String refreshToken;

  JwtDTO({required this.accessToken, required this.refreshToken});

  factory JwtDTO.fromJson(Map<String, dynamic> json) {
    return JwtDTO(
        accessToken: json['accessToken'], refreshToken: json['refreshToken']);
  }
}
