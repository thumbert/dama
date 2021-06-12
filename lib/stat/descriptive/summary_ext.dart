library stat.descriptive.summary_ext;

import 'summary.dart' as summary;

extension SummaryExtensions on Iterable<num> {
  num max() => summary.max(this);
  num min() => summary.min(this);
  List<num> range() => summary.range(this);
  num sum() => summary.sum(this);
  num mean() => summary.mean(this);
  num variance() => summary.variance(this);
}
