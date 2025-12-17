class FeedbackItem {
  final String nama;
  final String nim;
  final String fakultas;
  final List<String> fasilitas;
  final double nilaiKepuasan;
  final String jenisFeedback;
  final String pesanTambahan;
  final bool setujuSyarat;

  FeedbackItem({
    required this.nama,
    required this.nim,
    required this.fakultas,
    required this.fasilitas,
    required this.nilaiKepuasan,
    required this.jenisFeedback,
    this.pesanTambahan = '',
    required this.setujuSyarat,
  });
}
