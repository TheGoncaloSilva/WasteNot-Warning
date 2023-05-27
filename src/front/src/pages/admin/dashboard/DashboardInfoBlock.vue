<template>
  <div class="row row-equal">
    <div class="flex xl6 xs12 lg6">
      <div class="row">
        <div v-for="(info, idx) in infoTiles" :key="idx" class="flex xs12 sm4">
          <va-card class="mb-4" :color="info.color">
            <va-card-content>
              <h2 class="va-h2 ma-0" style="color: white">{{ info.value }}</h2>
              <p style="color: white">{{ t('dashboard.info.' + info.text) }}</p>
            </va-card-content>
          </va-card>
        </div>
      </div>

      <div class="row">
        <div class="flex xs12 sm6 md6">
          <va-card>
            <va-card-content>
              <h2 class="va-h2 ma-0" :style="{ color: colors.primary }">291</h2>
              <p class="no-wrap">{{ t('dashboard.info.completedPullRequests') }}</p>
            </va-card-content>
          </va-card>
        </div>
        <div class="flex xs12 sm6 md6">
          <va-card>
            <va-card-content>
              <div class="row row-separated">
                <div class="flex xs4">
                  <h2 class="va-h2 ma-0 va-text-center" :style="{ color: colors.primary }">3</h2>
                  <p class="va-text-center">{{ t('dashboard.info.users') }}</p>
                </div>
                <div class="flex xs4">
                  <h2 class="va-h2 ma-0 va-text-center" :style="{ color: colors.info }">24</h2>
                  <p class="va-text-center no-wrap">{{ t('dashboard.info.points') }}</p>
                </div>
                <div class="flex xs4">
                  <h2 class="va-h2 ma-0 va-text-center" :style="{ color: colors.warning }">91</h2>
                  <p class="va-text-center">{{ t('dashboard.info.units') }}</p>
                </div>
              </div>
            </va-card-content>
          </va-card>
        </div>
      </div>
    </div>

    <div class="flex xs12 sm6 md6 xl3 lg3">
      <va-card class="d-flex">
        <va-card-content>
            <div class="system-arm-section">
              <button :class="['outer-button', {'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}]">
                <button :class="['inner-button', {'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}]" @click="toggleArmedStatus">
                  {{ getSystemStatus() }}
                </button>
                <span :class="{'armed': isArmed && !alarmTriggered, 'disarmed': !isArmed && !alarmTriggered , 'triggered': alarmTriggered}">
                  {{ getSystemStatus() }}
                </span>
              </button>
            </div>
          
        </va-card-content>
      </va-card>
    </div>

    <div class="flex xs12 sm6 md6 xl3 lg3">
      <va-card stripe stripe-color="info">
        <va-card-title>
          System Description
        </va-card-title>
        <va-card-content>
          <p class="rich-theme-card-text">
            {{ getSystemDescription() }}
          </p>

          <div class="mt-3">
            <va-button color="primary" @click="triggerAlarm" v-if="isArmed && !alarmTriggered">
              Trigger System
            </va-button>
            <va-button color="primary" disabled v-else>
              Trigger System
            </va-button>
          </div>
        </va-card-content>
      </va-card>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref } from 'vue'
  import { useI18n } from 'vue-i18n'
  import { VaCarousel, VaModal, VaCard, VaCardContent, VaCardTitle, VaButton, VaImage, useColors } from 'vuestic-ui'

  const { t } = useI18n()
  const { colors } = useColors()

  let alarmTriggered = ref(false)
  let isArmed = ref(true)

  const infoTiles = ref([
    {
      color: 'success',
      value: '803',
      text: 'commits',
      icon: '',
    },
    {
      color: 'danger',
      value: '57',
      text: 'components',
      icon: '',
    },
    {
      color: 'info',
      value: '5',
      text: 'teamMembers',
      icon: '',
    },
  ])

  const modal = ref(false)
  const currentImageIndex = ref(0)
  const images = ref([
    'https://i.imgur.com/qSykGko.jpg',
    'https://i.imgur.com/jYwT08D.png',
    'https://i.imgur.com/9930myH.jpg',
    'https://i.imgur.com/2JxhWD6.jpg',
    'https://i.imgur.com/MpiOWbM.jpg',
  ])

  function showModal() {
    modal.value = true
  }

  function toggleArmedStatus() {
    isArmed.value = !isArmed.value;
    alarmTriggered.value = false
  }

  function triggerAlarm(){
    if(isArmed.value)
      alarmTriggered.value = true
  }

  function getSystemStatus(): String {
    if (alarmTriggered.value)
      return 'Triggered';
    else if (isArmed.value)
      return 'Armed'
    else
      return 'Disarmed'
  }

  function getSystemDescription(): String {
    if (alarmTriggered.value)
      return 'The Alarm has been Triggered, please check the device and the restricted area. To stop it, press the Triggered button';
    else if (isArmed.value)
      return 'The Alarm is currently Armed and functioning'
    else
      return "The Alarm is currently disabled and won't be activated, please press to activate it"
  }
</script>

<style lang="scss" scoped>
  .row-separated {
    .flex + .flex {
      border-left: 1px solid var(--va-background-primary);
    }
  }

  .rich-theme-card-text {
    line-height: 1.5;
  }

  .gallery-carousel {
    width: 80vw;
    max-width: 100%;

    @media all and (max-width: 576px) {
      width: 100%;
    }
  }

  .system-arm-section {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .outer-button {
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    width: 200px;
    height: 190px;
    border-radius: 50%;
    font-size: 18px;
    font-weight: bold;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  /* Updated CSS for the outer button */
  .outer-button::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border-radius: 50%;
    background-color: transparent;
    z-index: -1;
  }

  .inner-button {
    position: absolute;
    top: 25%;
    left: 25%;
    width: 50%;
    height: 50%;
    border-radius: 50%;
    color: white;
    font-size: 18px;
    font-weight: bold;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .armed .inner-button {
    background-color: green;
  }

  .armed .outer-button {
    background-color: green;
  }
  .triggered .outer-button {
    background-color: red;
  }

  .disarmed .inner-button {
    background-color: grey;
  }

  .disarmed .outer-button {
    background-color: grey;
  }

  .triggered .inner-button {
    background-color: red;
  }

  .armed span {
    color: green;
  }

  .disarmed span {
    color: grey;
  }

  .triggered span {
    color: red;
  }

  .outer-button:hover {
    opacity: 0.8;
  }

  .outer-button:focus {
    outline: none;
  }
</style>
