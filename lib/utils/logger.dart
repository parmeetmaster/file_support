import 'package:logger/logger.dart';

extension logs on String {
  get printerror => Logger().e(this);
  get printwarn => Logger().w(this);
  get printinfo => Logger().i(this);
  get printwtf => Logger().wtf(this);
  get printverbose => Logger().v(this);
}
