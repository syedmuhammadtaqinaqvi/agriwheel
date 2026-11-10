import { supabase } from './supabase';

export async function verificationDocUrl(userId: string, fileName: string): Promise<string | null> {
  const path = `${userId}/${fileName}`;
  const { data, error } = await supabase.storage.from('verification-docs').createSignedUrl(path, 3600);
  if (error) return null;
  return data.signedUrl;
}

export async function listVerificationDocs(userId: string): Promise<string[]> {
  const { data, error } = await supabase.storage.from('verification-docs').list(userId);
  if (error || !data) return [];
  return data.map((f) => f.name).filter((n) => n.endsWith('.jpg') || n.endsWith('.jpeg') || n.endsWith('.png'));
}
