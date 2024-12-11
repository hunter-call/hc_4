final List<String> subjects = [
  'Business',
  'Design',
  'Programming',
  'Marketing',
  'SEO',
  'Advertisement'
];

String getSubjectIcon(String subject) {
  switch (subject) {
    case 'Business':
      return 'assets/images/Vector.svg';
    case 'Design':
      return 'assets/images/Vector (1).svg';
    case 'Programming':
      return 'assets/images/Vector (2).svg';
    case 'Marketing':
      return 'assets/images/Vector (3).svg';
    case 'SEO':
      return 'assets/images/Vector (4).svg';
    case 'Advertisement':
      return 'assets/images/Vector (5).svg';
    default:
      return 'assets/images/default.svg';
  }
}
