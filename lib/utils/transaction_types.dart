List<String> getTransactionTypes({required bool isTransaction}) {
  const allTypes = [
    'খরচ',
    'মূলধন জমা',
    'মূলধন উত্তোলন',
    'টাকা স্থানান্তর',
  ];

  if (isTransaction) {
    return allTypes;
  } else {
    return [
      'খরচ',
      'মূলধন জমা',
    ];
  }
}
