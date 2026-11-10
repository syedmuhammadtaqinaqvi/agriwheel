import 'package:supabase_flutter/supabase_flutter.dart';

/// Global Supabase client accessor — never embed keys outside [main.dart] + dotenv.
SupabaseClient get supabase => Supabase.instance.client;
