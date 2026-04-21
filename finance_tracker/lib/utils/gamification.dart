String getBadge(double total) {
  if (total >= 5000) return 'Big Spender';
  if (total >= 3000) return 'Active Tracker';
  if (total >= 1000) return 'Budget Beginner';
  return 'Starter';
}
