<template>
  <el-row type="flex" :gutter="20">
    <el-col :md="10" :lg="8">
      <el-card class="admin-info">
        <el-row :gutter="20">
          <el-col :span="10">
            <img class="avatar" :src="profile.avatar"/>
          </el-col>
          <el-col :span="14">
            <p class="admin-info-name">{{user.username}}</p>
            <p>{{user.admin_type}}</p>
          </el-col>
        </el-row>
        <hr/>
        <div class="last-info">
          <p class="last-info-title">{{$t('m.Last_Login')}}</p>
          <el-form label-width="80px" class="last-info-body">
            <el-form-item label="Time:">
              <span>{{session.last_activity | localtime}}</span>
            </el-form-item>
            <el-form-item label="IP:">
              <span>{{session.ip}}</span>
            </el-form-item>
            <el-form-item label="OS">
              <span>{{os}}</span>
            </el-form-item>
            <el-form-item label="Browser:">
              <span>{{browser}}</span>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      <panel :title="$t('m.System_Overview')" v-if="isSuperAdmin">
        <p>{{$t('m.DashBoardJudge_Server')}}:  {{infoData.judge_server_count}}</p>
        <p>{{$t('m.HTTPS_Status')}}:
          <el-tag :type="https ? 'success' : 'danger'" size="small">
            {{ https ? 'Enabled' : 'Disabled'}}
          </el-tag>
        </p>
        <p>{{$t('m.Force_HTTPS')}}:
          <el-tag :type="forceHttps ? 'success' : 'danger'" size="small">
            {{forceHttps ? 'Enabled' : 'Disabled'}}
          </el-tag>
        </p>
        <p>{{$t('m.CDN_HOST')}}:
          <el-tag :type="cdn ? 'success' : 'warning'" size="small">
            {{cdn ? cdn : 'Not Use'}}
          </el-tag>
        </p>
      </panel>
    </el-col>

    <el-col :md="14" :lg="16" v-if="isSuperAdmin">
      <div class="info-container">
        <info-card color="#909399" icon="el-icon-fa-users" :message="$t('m.User_User')" iconSize="30px" class="info-item"
                   :value="infoData.user_count"></info-card>
        <info-card color="#67C23A" icon="el-icon-fa-list" :message="$t('m.MySubmissions')" class="info-item"
                   :value="infoData.today_submission_count"></info-card>
        <info-card color="#409EFF" icon="el-icon-fa-trophy" :message="$t('m.Contests')" class="info-item"
                   :value="infoData.recent_contest_count"></info-card>
      </div>
      <panel style="margin-top: 5px">
        <span slot="title">版本更新与架构升级说明 (Release Notes)</span>

        <el-collapse v-model="activeNames">
          <el-collapse-item name="1">
            <template slot="title">
              <div>XOJ-Pro 现代全栈架构升级版
                <el-tag size="mini" type="success">2026 最新版</el-tag>
              </div>
            </template>
            <p><strong>Level:</strong> Core Architecture & UI Overhaul (Major Update)</p>
            <br>
            <p><strong>技术架构与升级详情:</strong></p>
            <div class="release-body">
              <ul>
                <li><strong>前端视觉革新 (Glassmorphism & Interactive UI)</strong>: 彻底重写了主题驱动核心 (`themes.less`)，解除了基于老旧 `iView` 组件的多项限制。全站实现了强烈的全局大圆角、悬浮动态阴影与半透明卡片设计。</li>
                <li><strong>深度国际化与本地化同步 (i18n Sync)</strong>: 打通了前台与后台 (Admin) 在 `Vuex` 和 `LocalStorage` 之间相互割裂的状态鸿沟。管理仪表盘 (Dashboard) 已全面实现国际化变量覆盖，并对语言切换做出毫秒级双端响应。</li>
                <li><strong>色彩调度机制 (Unified Theming)</strong>: 剔除了旧版干瘪的单调配色，引入包含动画特权的 <em>「赛博朋克深黑」</em>, <em>「卡通玩趣」</em>, <em>「深海微光」</em> 与 <em>「极光曼舞」</em> 等次世代深度交互主题。普通浅色与深色则保持极其克制的商务静谧感。</li>
                <li><strong>全局时空仪表 (AtCoder-style TimeBoard)</strong>: 在前台右下角植入悬浮的高级毛玻璃时间时钟板。可一键点击进入 30% 透明沉浸阻尼模式防遮挡。</li>
                <li><strong>Docker 环境与静态资源修复</strong>: 重构 `docker-compose.yml` 容器体积映射，成功将宿主机 `/data/backend/avatar` 穿透 Nginx 反向代理层，解决了历史遗留的管理员头像 404 死锁 Bug。</li>
              </ul>
            </div>
          </el-collapse-item>
        </el-collapse>
      </panel>
    </el-col>
  </el-row>
</template>


<script>
  import { mapGetters } from 'vuex'
  import browserDetector from 'browser-detect'
  import InfoCard from '@admin/components/infoCard.vue'
  import api from '@admin/api'

  export default {
    name: 'dashboard',
    components: {
      InfoCard
    },
    data () {
      return {
        infoData: {
          user_count: 0,
          recent_contest_count: 0,
          today_submission_count: 0,
          judge_server_count: 0,
          env: {}
        },
        activeNames: [1],
        session: {},
        loadingReleases: true,
        releases: []
      }
    },
    mounted () {
      api.getDashboardInfo().then(resp => {
        this.infoData = resp.data.data
      }, () => {
      })
      api.getSessions().then(resp => {
        this.parseSession(resp.data.data)
      }, () => {
      })
    },
    methods: {
      parseSession (sessions) {
        let session = sessions[0]
        if (sessions.length > 1) {
          session = sessions.filter(s => !s.current_session).sort((a, b) => {
            return a.last_activity < b.last_activity
          })[0]
        }
        this.session = session
      }
    },
    computed: {
      ...mapGetters(['profile', 'user', 'isSuperAdmin']),
      cdn () {
        return this.infoData.env.STATIC_CDN_HOST
      },
      https () {
        return document.URL.slice(0, 5) === 'https'
      },
      forceHttps () {
        return this.infoData.env.FORCE_HTTPS
      },
      browser () {
        let b = browserDetector(this.session.user_agent)
        if (b.name && b.version) {
          return b.name + ' ' + b.version
        } else {
          return 'Unknown'
        }
      },
      os () {
        let b = browserDetector(this.session.user_agent)
        return b.os ? b.os : 'Unknown'
      }
    }
  }
</script>

<style lang="less">
  .admin-info {
    margin-bottom: 20px;
    &-name {
      font-size: 24px;
      font-weight: 700;
      margin-bottom: 10px;
      color: #409EFF;
    }
    .avatar {
      max-width: 100%;
    }
    .last-info {
      &-title {
        font-size: 16px;
      }
      &-body {
        .el-form-item {
          margin-bottom: 5px;
        }
      }
    }
  }

  .info-container {
    display: flex;
    justify-content: flex-start;
    flex-wrap: wrap;
    .info-item {
      flex: 1 0 auto;
      min-width: 200px;
      margin-bottom: 10px;
    }
  }

</style>
