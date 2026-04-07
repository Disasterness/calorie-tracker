import { preferences } from '@kit.ArkData';
import { MacroModel } from '../models/MacroModel';

export class PersistenceService {
  private static readonly PREF_NAME = 'CalorieTrackerPrefs';
  private static readonly KEY_CURRENT = 'current_macros';
  private static readonly KEY_TARGET = 'target_macros';
  private static readonly KEY_HISTORY = 'macro_history';
  private static readonly KEY_LAST_DATE = 'last_date';
  private static instance: PersistenceService;
  private pref?: preferences.Preferences;

  private constructor() {}

  static getInstance(): PersistenceService {
    if (!PersistenceService.instance) {
      PersistenceService.instance = new PersistenceService();
    }
    return PersistenceService.instance;
  }

  async init(context: any) {
    this.pref = await preferences.getPreferences(context, PersistenceService.PREF_NAME);
  }

  async saveCurrentMacros(model: MacroModel) {
    if (!this.pref) return;
    await this.pref.put(PersistenceService.KEY_CURRENT, JSON.stringify(model));
    await this.pref.flush();
  }

  async saveTargetMacros(model: MacroModel) {
    if (!this.pref) return;
    await this.pref.put(PersistenceService.KEY_TARGET, JSON.stringify(model));
    await this.pref.flush();
  }

  async loadCurrentMacros(): Promise<MacroModel | null> {
    if (!this.pref) return null;
    const data = await this.pref.get(PersistenceService.KEY_CURRENT, '');
    if (data && typeof data === 'string' && data !== '') {
      try {
        const obj = JSON.parse(data) as Record<string, number>;
        return new MacroModel(obj.kcal, obj.carbs, obj.protein, obj.fat);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  async loadTargetMacros(): Promise<MacroModel | null> {
    if (!this.pref) return null;
    const data = await this.pref.get(PersistenceService.KEY_TARGET, '');
    if (data && typeof data === 'string' && data !== '') {
      try {
        const obj = JSON.parse(data) as Record<string, number>;
        return new MacroModel(obj.kcal, obj.carbs, obj.protein, obj.fat);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  async saveHistory(history: string) {
    if (!this.pref) return;
    await this.pref.put(PersistenceService.KEY_HISTORY, history);
    await this.pref.flush();
  }

  async loadHistory(): Promise<string> {
    if (!this.pref) return '[]';
    return await this.pref.get(PersistenceService.KEY_HISTORY, '[]') as string;
  }

  async saveLastDate(date: string) {
    if (!this.pref) return;
    await this.pref.put(PersistenceService.KEY_LAST_DATE, date);
    await this.pref.flush();
  }

  async loadLastDate(): Promise<string> {
    if (!this.pref) return '';
    return await this.pref.get(PersistenceService.KEY_LAST_DATE, '') as string;
  }
}
