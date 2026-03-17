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
      
      <div class="right-menu">
        <div class="settings-menu">
          <Dropdown class="theme-dropdown" trigger="click" @on-click="handleThemeChange">
            <Button type="text" size="small">
              <Icon type="ios-color-wand" size="18"></Icon>
              <span style="margin-left: 4px;">主题切换</span>
            </Button>
            <Dropdown-menu slot="list">
              <Dropdown-item name="default-light" :class="{'theme-active': currentTheme === 'default-light'}">
                <span class="theme-dot default-dot"></span> 默认浅色
              </Dropdown-item>
              <Dropdown-item name="default-dark" :class="{'theme-active': currentTheme === 'default-dark'}">
                <span class="theme-dot default-dark-dot"></span> 默认深色
              </Dropdown-item>
              <Dropdown-item name="cyberpunk-dark" :class="{'theme-active': currentTheme === 'cyberpunk-dark'}">
                <span class="theme-dot cyberpunk-dot"></span> 赛博朋克
              </Dropdown-item>
              <Dropdown-item name="cartoon-fun" :class="{'theme-active': currentTheme === 'cartoon-fun'}">
                <span class="theme-dot cartoon-dot"></span> 卡通玩趣
              </Dropdown-item>
              <Dropdown-item name="ocean-breeze" :class="{'theme-active': currentTheme === 'ocean-breeze'}">
                <span class="theme-dot ocean-dot"></span> 深海微光
              </Dropdown-item>
              <Dropdown-item name="aurora-glow" :class="{'theme-active': currentTheme === 'aurora-glow'}">
                <span class="theme-dot aurora-dot"></span> 极光曼舞
              </Dropdown-item>
            </Dropdown-menu>
          </Dropdown>
          
          <div class="lang-btn" @click="toggleLocale" style="cursor: pointer; display: inline-flex; align-items: center; user-select: none;">
            <Button type="text" size="small">
              <Icon type="earth" size="18"></Icon>
              <span style="margin-left: 4px;">{{ currentLangLabel }}</span>
            </Button>
          </div>
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
                    style="margin-left: 10px;">{{$t('m.Register')}}
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
      </div>
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
          { value: 'default-light', label: '默认浅色' },
          { value: 'default-dark', label: '默认深色' },
          { value: 'cyberpunk-dark', label: '赛博朋克' },
          { value: 'cartoon-fun', label: '卡通玩趣' },
          { value: 'ocean-breeze', label: '深海微光' },
          { value: 'aurora-glow', label: '极光曼舞' }
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
      toggleLocale () {
        const newLocale = this.locale === 'zh-CN' ? 'en-US' : 'zh-CN'
        this.$store.commit(types.CHANGE_LOCALE, newLocale)
        this.$i18n.locale = newLocale
      },
      handleThemeChange (name) {
        this.$store.commit(types.CHANGE_THEME, name)
      }
    },
    computed: {
      ...mapGetters(['website', 'modalStatus', 'user', 'isAuthenticated', 'isAdminRole', 'locale', 'currentTheme']),
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
    background-color: var(--header-bg, rgba(255, 255, 255, 0.85));
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    box-shadow: var(--shadow-color, 0 4px 30px rgba(0, 0, 0, 0.05));
    .oj-menu {
      background: transparent;
    }

    .logo {
      margin-left: 2%;
      margin-right: 2%;
      font-size: 20px;
      float: left;
      line-height: 60px;
    }

    .right-menu {
      float: right;
      display: flex;
      align-items: center;
      height: 60px;
      margin-right: 30px;
      & > * {
        margin-left: 20px;
      }
    }

    .settings-menu {
      display: flex;
      align-items: center;
      gap: 12px;
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
      background: linear-gradient(135deg, #e5e5ea, #f2f2f7);
      border: 1px solid #d1d1d6;
    }

    .default-dark-dot {
      background: linear-gradient(135deg, #0f172a, #3b82f6);
    }

    .cyberpunk-dot {
      background: linear-gradient(135deg, #ff00ff, #00ffff);
    }

    .cartoon-dot {
      background: linear-gradient(135deg, #ff7675, #ffeaa7);
    }

    .ocean-dot {
      background: linear-gradient(135deg, #00d2d3, #012133);
    }

    .aurora-dot {
      background: linear-gradient(135deg, #a29bfe, #00cec9);
    }

    .theme-active {
      background-color: #f0f0f0;
      font-weight: 600;
    }

    .drop-menu {
      &-title {
        font-size: 16px;
      }
    }
    .btn-menu {
      font-size: 16px;
      display: flex;
      gap: 8px;
    }
  }

  .modal {
    &-title {
      font-size: 18px;
      font-weight: 600;
    }
  }
</style>
