import dataPreferences from '@ohos.data.preferences';
import JSON from '@ohmos/json-bigint';
import { User } from '../service/UserService';
import { Pair } from './Pair';

const PREFERENCES_NAME = "top.wangchenyan.wanharmony"
const KEY_USER_INFO = "user_info";
const KEY_SEARCH_HISTORY = "search_history";
const KEY_SELECTED_TREE_ID_1 = "selected_tree_id_1";
const KEY_SELECTED_TREE_ID_2 = "selected_tree_id_2";

export default class Preferences {
  private static instance: Preferences;
  private preferences: dataPreferences.Preferences;

  private constructor(context: Context) {
    this.preferences = dataPreferences.getPreferencesSync(context, {
      name: PREFERENCES_NAME
    });
  }

  getUser(): User | undefined {
    const json = this.preferences.getSync(KEY_USER_INFO, "");
    if (json) {
      const user: User = JSON.parse(json)
      return user;
    } else {
      return undefined;
    }
  }

  putUser(user?: User) {
    if (user) {
      this.preferences.putSync(KEY_USER_INFO, JSON.stringify(user, undefined, undefined));
    } else {
      this.preferences.deleteSync(KEY_USER_INFO);
    }
    this.preferences.flush();
  }

  getSearchHistory(): string[] {
    return this.preferences.getSync(KEY_SEARCH_HISTORY, []) as string[];
  }

  putSearchHistory(historyKeys: string[]) {
    this.preferences.putSync(KEY_SEARCH_HISTORY, historyKeys)
    this.preferences.flush()
  }

  getSelectedTreeId(): Pair<number, number> {
    const id1 = this.preferences.getSync(KEY_SELECTED_TREE_ID_1, 0) as number;
    const id2 = this.preferences.getSync(KEY_SELECTED_TREE_ID_2, 0) as number;
    if (id1 > 0 && id2 > 0) {
      return new Pair(id1, id2);
    } else {
      return new Pair(0, 0);
    }
  }

  putSelectedTreeId(treeId1: number, treeId2: number) {
    this.preferences.putSync(KEY_SELECTED_TREE_ID_1, treeId1);
    this.preferences.putSync(KEY_SELECTED_TREE_ID_2, treeId2);
    this.preferences.flush()
  }

  static get(context: Context): Preferences {
    if (Preferences.instance === undefined) {
      Preferences.instance = new Preferences(context);
    }
    return Preferences.instance;
  }
}