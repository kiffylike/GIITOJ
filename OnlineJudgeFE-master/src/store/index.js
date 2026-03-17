import Vue from 'vue'
import Vuex from 'vuex'
import user from './modules/user'
import contest from './modules/contest'
import api from '@oj/api'
import types from './types'

Vue.use(Vuex)
const debug = process.env.NODE_ENV !== 'production'

const rootState = {
  website: {},
  modalStatus: {
    mode: 'login',
    visible: false
  },
  locale: 'zh-CN',
  currentTheme: 'default-light'
}

const rootGetters = {
  'website' (state) {
    return state.website
  },
  'modalStatus' (state) {
    return state.modalStatus
  },
  'locale' (state) {
    return state.locale
  },
  'currentTheme' (state) {
    return state.currentTheme
  }
}

const rootMutations = {
  [types.UPDATE_WEBSITE_CONF] (state, payload) {
    state.website = payload.websiteConfig
  },
  [types.CHANGE_MODAL_STATUS] (state, {mode, visible}) {
    if (mode !== undefined) {
      state.modalStatus.mode = mode
    }
    if (visible !== undefined) {
      state.modalStatus.visible = visible
    }
  },
  [types.CHANGE_LOCALE] (state, locale) {
    state.locale = locale
    localStorage.setItem('locale', locale)
  },
  [types.CHANGE_THEME] (state, theme) {
    state.currentTheme = theme
    localStorage.setItem('currentTheme', theme)
    document.documentElement.setAttribute('data-theme', theme)
  }
}

const rootActions = {
  getWebsiteConfig ({commit}) {
    api.getWebsiteConf().then(res => {
      commit(types.UPDATE_WEBSITE_CONF, {
        websiteConfig: res.data.data
      })
    })
  },
  changeModalStatus ({commit}, payload) {
    commit(types.CHANGE_MODAL_STATUS, payload)
  },
  changeDomTitle ({commit, state}, payload) {
    if (payload && payload.title) {
      window.document.title = state.website.website_name_shortcut + ' | ' + payload.title
    } else {
      window.document.title = state.website.website_name_shortcut + ' | ' + state.route.meta.title
    }
  },
  initThemeAndLocale ({commit}) {
    const savedLocale = localStorage.getItem('locale')
    let savedTheme = localStorage.getItem('currentTheme')
    
    // Auto-migrate old theme names to premium 2026 themes
    if (savedTheme === 'default' || !savedTheme) savedTheme = 'default-light'
    if (savedTheme === 'github') savedTheme = 'default-light'
    if (savedTheme === 'vscode') savedTheme = 'default-dark'
    if (savedTheme === 'material') savedTheme = 'ocean-breeze'
    if (savedTheme === 'cyberpunk') savedTheme = 'cyberpunk-dark'
    if (savedTheme === 'anime') savedTheme = 'cartoon-fun'

    if (savedLocale) {
      commit(types.CHANGE_LOCALE, savedLocale)
    } else {
      commit(types.CHANGE_LOCALE, 'zh-CN')
    }
    
    commit(types.CHANGE_THEME, savedTheme)
  }
}

export default new Vuex.Store({
  modules: {
    user,
    contest
  },
  state: rootState,
  getters: rootGetters,
  mutations: rootMutations,
  actions: rootActions,
  strict: debug
})

export { types }
