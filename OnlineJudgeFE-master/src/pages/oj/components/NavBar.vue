<template>
  <div id="header">
    <Menu theme="light" mode="horizontal" @on-select="handleRoute" :active-name="activeMenu" class="oj-menu">
      <div class="logo"><span>{{website.website_name}}</span></div>
      <Menu-item name="/">
        <Icon type="home"></Icon>
        {{$t('m.Home')}}
      </Menu-item>
      <Menu-item name="/problem">
        <Icon type="ios-keypad"></Icon>
        {{$t('m.NavProblems')}}
      </Menu-item>
      <Menu-item name="/contest">
        <Icon type="trophy"></Icon>
        {{$t('m.Contests')}}
      </Menu-item>
      <Menu-item name="/status">
        <Icon type="ios-pulse-strong"></Icon>
        {{$t('m.NavStatus')}}
      </Menu-item>
      <Submenu name="rank">
        <template slot="title">
          <Icon type="podium"></Icon>
          {{$t('m.Rank')}}
        </template>
        <Menu-item name="/acm-rank">
          {{$t('m.ACM_Rank')}}
        </Menu-item>
        <Menu-item name="/oi-rank">
          {{$t('m.OI_Rank')}}
        </Menu-item>
      </Submenu>
      <Submenu name="about">
        <template slot="title">
          <Icon type="information-circled"></Icon>
          {{$t('m.About')}}
        </template>
        <Menu-item name="/about">
          {{$t('m.Judger')}}
        </Menu-item>
        <Menu-item name="/FAQ">
          {{$t('m.FAQ')}}
        </Menu-item>
      </Submenu>
      
      <div class="settings-menu">
        <Dropdown class="theme-dropdown" trigger="click">
          <Button type="text" size="small">
            <Icon :type="darkMode ? 'moon' : 'sunny'" size="18"></Icon>
          </Button>
          <Dropdown-menu slot="list">
            <Dropdown-item @click="toggleDarkMode">
              <Icon :type="darkMode ? 'sunny' : 'moon'" style="margin-right: 8px;"></Icon>
              {{ darkMode ? '浅色模式' : '深色模式' }}
            </Dropdown-item>
            <Dropdown-item divided>
              <span style="font-weight: 600;">主题选择</span>
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('default')" :class="{'theme-active': currentTheme === 'default'}">
              <span class="theme-dot default-dot"></span> 默认主题
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('github')" :class="{'theme-active': currentTheme === 'github'}">
              <span class="theme-dot github-dot"></span> GitHub
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('vscode')" :class="{'theme-active': currentTheme === 'vscode'}">
              <span class="theme-dot vscode-dot"></span> VS Code
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('material')" :class="{'theme-active': currentTheme === 'material'}">
              <span class="theme-dot material-dot"></span> Material
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('cyberpunk')" :class="{'theme-active': currentTheme === 'cyberpunk'}">
              <span class="theme-dot cyberpunk-dot"></span> 赛博朋克
            </Dropdown-item>
            <Dropdown-item @click="changeTheme('anime')" :class="{'theme-active': currentTheme === 'anime'}">
              <span class="theme-dot anime-dot"></span> 二次元
            </Dropdown-item>
          </Dropdown-menu>
        </Dropdown>
        
        <Dropdown class="lang-dropdown" trigger="click">
          <Button type="text" size="small">
            <Icon type="earth" size="18"></Icon>
            <span style="margin-left: 4px;">{{ currentLangLabel }}</span>
          </Button>
          <Dropdown-menu slot="list">
            <Dropdown-item v-for="lang in languages" :key="lang.value" @click="changeLocale(lang.value)">
              {{ lang.label }}
            </Dropdown-item>
          </Dropdown-menu>
        </Dropdown>
      </div>
      
      <template v-if="!isAuthenticated">
        <div class="btn-menu">
          <Button type="ghost"
                  ref="loginBtn"
                  shape="circle"
                  @click="handleBtnClick('login')">{{$t('m.Login')}}
          </Button>
          <Button v-if="website.allow_register"
                  type="ghost"
                  shape="circle"
                  @click="handleBtnClick('register')"
                  style="margin-left: 5px;">{{$t('m.Register')}}
          </Button>
        </div>
      </template>
      <template v-else>
        <Dropdown class="drop-menu" @on-click="handleRoute" placement="bottom" trigger="click">
          <Button type="text" class="drop-menu-title">{{ user.username }}
            <Icon type="arrow-down-b"></Icon>
          </Button>
          <Dropdown-menu slot="list">
            <Dropdown-item name="/user-home">{{$t('m.MyHome')}}</Dropdown-item>
            <Dropdown-item name="/status?myself=1">{{$t('m.MySubmissions')}}</Dropdown-item>
            <Dropdown-item name="/setting/profile">{{$t('m.Settings')}}</Dropdown-item>
            <Dropdown-item v-if="isAdminRole" name="/admin">{{$t('m.Management')}}</Dropdown-item>
            <Dropdown-item divided name="/logout">{{$t('m.Logout')}}</Dropdown-item>
          </Dropdown-menu>
        </Dropdown>
      </template>
    </Menu>
    <Modal v-model="modalVisible" :width="400">
      <div slot="header" class="modal-title">{{$t('m.Welcome_to')}} {{website.website_name_shortcut}}</div>
      <component :is="modalStatus.mode" v-if="modalVisible"></component>
      <div slot="footer" style="display: none"></div>
    </Modal>
  </div>
</template>

<script>
  import { mapGetters, mapActions } from 'vuex'
  import login from '@oj/views/user/Login'
  import register from '@oj/views/user/Register'
  import { languages } from '@/i18n'
  import types from '@/store/types'

  export default {
    components: {
      login,
      register
    },
    mounted () {
      this.getProfile()
    },
    data () {
      return {
        languages: languages,
        themes: [
          { value: 'default', label: '默认主题' },
          { value: 'github', label: 'GitHub' },
          { value: 'vscode', label: 'VS Code' },
          { value: 'material', label: 'Material' },
          { value: 'cyberpunk', label: '赛博朋克' },
          { value: 'anime', label: '二次元' }
        ]
      }
    },
    methods: {
      ...mapActions(['getProfile', 'changeModalStatus']),
      handleRoute (route) {
        if (route && route.indexOf('admin') < 0) {
          this.$router.push(route)
        } else {
          window.open('/admin/')
        }
      },
      handleBtnClick (mode) {
        this.changeModalStatus({
          visible: true,
          mode: mode
        })
      },
      changeLocale (locale) {
        this.$store.commit(types.CHANGE_LOCALE, locale)
        this.$i18n.locale = locale
      },
      toggleDarkMode () {
        this.$store.commit(types.CHANGE_DARK_MODE, !this.darkMode)
      },
      changeTheme (theme) {
        this.$store.commit(types.CHANGE_THEME, theme)
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus', 'user', 'isAuthenticated', 'isAdminRole', 'locale', 'darkMode', 'currentTheme']),
      activeMenu () {
        return '/' + this.$route.path.split('/')[1]
      },
      modalVisible: {
        get () {
          return this.modalStatus.visible
        },
        set (value) {
          this.changeModalStatus({visible: value})
        }
      },
      currentLangLabel () {
        const lang = this.languages.find(l => l.value === this.locale)
        return lang ? lang.label : '简体中文'
      }
    }
  }
</script>

<style lang="less" scoped>
  #header {
    min-width: 300px;
    position: fixed;
    top: 0;
    left: 0;
    height: auto;
    width: 100%;
    z-index: 1000;
    background-color: #fff;
    box-shadow: 0 1px 5px 0 rgba(0, 0, 0, 0.1);
    .oj-menu {
      background: #fdfdfd;
      display: flex;
      align-items: center;
    }

    .logo {
      margin-left: 2%;
      margin-right: 2%;
      font-size: 20px;
      float: left;
      line-height: 60px;
    }

    .settings-menu {
      display: flex;
      align-items: center;
      margin-left: auto;
      margin-right: 100px;
      gap: 8px;
    }

    .theme-dropdown,
    .lang-dropdown {
      .ivu-btn {
        padding: 4px 8px;
        height: auto;
      }
    }

    .theme-dot {
      display: inline-block;
      width: 14px;
      height: 14px;
      border-radius: 50%;
      margin-right: 8px;
      vertical-align: middle;
    }

    .default-dot {
      background: linear-gradient(135deg, #2d8cf0, #5cadff);
    }

    .github-dot {
      background: linear-gradient(135deg, #24292e, #0366d6);
    }

    .vscode-dot {
      background: linear-gradient(135deg, #007acc, #1e1e1e);
    }

    .material-dot {
      background: linear-gradient(135deg, #6200ee, #03dac6);
    }

    .cyberpunk-dot {
      background: linear-gradient(135deg, #ff00ff, #00ffff);
    }

    .anime-dot {
      background: linear-gradient(135deg, #ff6b9d, #c44569);
    }

    .theme-active {
      background-color: #f0f0f0;
      font-weight: 600;
    }

    .drop-menu {
      float: right;
      margin-right: 30px;
      position: absolute;
      right: 10px;
      &-title {
        font-size: 18px;
      }
    }
    .btn-menu {
      font-size: 16px;
      float: right;
      margin-right: 10px;
    }
  }

  .modal {
    &-title {
      font-size: 18px;
      font-weight: 600;
    }
  }
</style>
