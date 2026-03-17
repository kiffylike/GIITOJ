<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
  import { mapGetters } from 'vuex'
  export default {
    name: 'app',
    computed: {
      ...mapGetters(['locale'])
    },
    watch: {
      locale: {
        immediate: true,
        handler (newVal) {
          this.$i18n.locale = newVal
        }
      }
    }
  }
</script>

<style lang="less">
  body {
    margin: 0;
    padding: 0;
    font-family: "Helvetica Neue",Helvetica,"PingFang SC","Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif;
    font-size: 14px;
    -webkit-font-smoothing: antialiased;
    background-color: #324157;
  }

  #app {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 100%;
  }
</style>
