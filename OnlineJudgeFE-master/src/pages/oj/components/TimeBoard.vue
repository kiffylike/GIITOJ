<template>
  <div class="time-board" :class="{'glass-mode': isGlass}" @click="toggleGlass">
    <div class="time-board-inner">
      <div class="date-row">{{ currentDate }} ({{ currentDay }})</div>
      <div class="time-row">{{ currentTime }} <span class="tz">+08:00</span></div>
    </div>
  </div>
</template>

<script>
  import moment from 'moment'

  export default {
    name: 'TimeBoard',
    data () {
      return {
        timer: null,
        now: moment(),
        isGlass: false
      }
    },
    computed: {
      currentDate () {
        return this.now.format('YYYY-MM-DD')
      },
      currentDay () {
        return this.now.format('ddd')
      },
      currentTime () {
        return this.now.format('HH:mm:ss')
      }
    },
    mounted () {
      this.timer = setInterval(() => {
        this.now = moment()
      }, 1000)
    },
    beforeDestroy () {
      if (this.timer) {
        clearInterval(this.timer)
      }
    },
    methods: {
      toggleGlass () {
        this.isGlass = !this.isGlass
      }
    }
  }
</script>

<style lang="less" scoped>
  .time-board {
    position: fixed;
    bottom: 30px;
    right: 30px;
    z-index: 9999;
    background: var(--surface-color, rgba(230,230,230,0.9));
    color: var(--text-color, #333);
    padding: 12px 20px;
    border-radius: 12px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    border: 2px solid var(--border-color, rgba(100,100,100,0.3));
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    cursor: pointer;
    user-select: none;
    transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
    transform-origin: bottom right;

    &:hover {
      transform: translateY(-5px) scale(1.02);
      box-shadow: 0 15px 40px rgba(0, 0, 0, 0.3);
      border-color: var(--primary-color, #409EFF);
    }

    &.glass-mode {
      opacity: 0.25;
      transform: scale(0.95);
      &:hover {
        opacity: 0.8;
      }
    }

    .time-board-inner {
      text-align: center;
      font-family: 'Consolas', 'Courier New', monospace;
      font-weight: 600;
      letter-spacing: 0.5px;
      
      .date-row {
        font-size: 16px;
        margin-bottom: 4px;
        opacity: 0.85;
      }
      .time-row {
        font-size: 22px;
        color: var(--primary-color, #409EFF);
        .tz {
          font-size: 14px;
          opacity: 0.6;
          font-weight: 400;
        }
      }
    }
  }
</style>
