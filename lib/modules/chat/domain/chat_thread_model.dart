class ChatThread {
  const ChatThread({
    required this.id,
    required this.name,
    required this.initials,
    required this.timeLabel,
    required this.snippet,
    required this.machineryTag,
    required this.priceHint,
    required this.category,
    this.unreadCount = 0,
    this.online = false,
    this.verified = false,
    this.dealer = false,
    this.thumbUrl,
  });

  final String id;
  final String name;
  final String initials;
  final String timeLabel;
  final String snippet;
  final String machineryTag;
  final String priceHint;
  final String category;
  final int unreadCount;
  final bool online;
  final bool verified;
  final bool dealer;
  final String? thumbUrl;

  static const demoThreads = [
    ChatThread(
      id: 'haji-rafiq',
      name: 'Haji Rafiq Chaudhry',
      initials: 'HR',
      timeLabel: '10:42 AM',
      snippet: 'Ji bhai 33 lac final ho jaye ga. Mandi dekh lein.',
      machineryTag: 'MF 385 4WD',
      priceHint: 'Rs 3,300,000',
      category: 'buying',
      unreadCount: 2,
      online: true,
      verified: true,
      thumbUrl:
          'https://lh3.googleusercontent.com/aida/ALJJyrDnBGzSAYbJCS41oMJWOw6bHl5xz8AqICVN9d_ue6OIFJtZn5BBVPvPTUgqjEkocyom8bM846lan2ZCvSy7Yig87aLnXNxowI66_HkrfkOd9jEXfIW7vQSH9WLE91-NwGSoSULFr-0auygvF57d_nVr325EtpGBhqR88QRfgfsUMaUGcHuR-WOBFJE9buno5J_upXzs2kKzIMTCq4WlUEgNYgfKOBR53tRqmDcEeTZQ',
    ),
    ChatThread(
      id: 'al-madina',
      name: 'Al-Madina Agro Traders',
      initials: 'AM',
      timeLabel: 'Yesterday',
      snippet: 'Biometric verification complete hai, documents ready.',
      machineryTag: 'Fiat 480 (1998)',
      priceHint: 'Verified Reg',
      category: 'buying',
      dealer: true,
    ),
    ChatThread(
      id: 'malik-agro',
      name: 'Malik Agro Multan',
      initials: 'MA',
      timeLabel: '2 days ago',
      snippet: 'Kab tak visit karenge harvester check karne?',
      machineryTag: 'John Deere W70',
      priceHint: 'Multan Mandi',
      category: 'selling',
    ),
    ChatThread(
      id: 'tariq',
      name: 'Tariq Farm Implements',
      initials: 'TF',
      timeLabel: '3 days ago',
      snippet: 'Available for delivery in Sahiwal region.',
      machineryTag: '11-Tine Rotavator',
      priceHint: 'New Tool',
      category: 'buying',
    ),
  ];
}
