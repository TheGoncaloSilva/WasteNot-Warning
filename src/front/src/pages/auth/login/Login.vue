<template>
  <form @submit.prevent="onsubmit">
    <va-input
      v-model="telefone"
      class="mb-3"
      type="telephone"
      label="Telefone"
      :error="!!telefoneErrors.length"
      :error-messages="telefoneErrors"
    />

    <va-input
      v-model="password"
      class="mb-3"
      type="password"
      :label="t('auth.password')"
      :error="!!passwordErrors.length"
      :error-messages="passwordErrors"
    />

    <div class="auth-layout__options d-flex align-center justify-space-between">
      <va-checkbox v-model="keepLoggedIn" class="mb-0" :label="t('auth.keep_logged_in')" />
      <router-link class="ml-1 va-link" :to="{ name: 'recover-password' }">{{
        t('auth.recover_password')
      }}</router-link>
    </div>

    <div class="d-flex justify-center mt-3">
      <va-button class="my-0" @click="onsubmit">{{ t('auth.login') }}</va-button>
    </div>
  </form>
</template>

<script setup lang="ts">

  import {BE_API} from '../../../services/backend-api/backend-api';

  import { computed, ref } from 'vue'
  import { useRouter } from 'vue-router'
  import { useI18n } from 'vue-i18n'
import route from '../../admin/ui/route';
  const { t } = useI18n()

  const telefone = ref('')
  const password = ref('')
  const keepLoggedIn = ref(false)
  const telefoneErrors = ref<string[]>([])
  const passwordErrors = ref<string[]>([])
  const router = useRouter()

  const formReady = computed(() => !telefoneErrors.value.length && !passwordErrors.value.length)

  localStorage.setItem('auth-token',"")

  async function onsubmit() {
    passwordErrors.value = []
    if (!formReady.value) return


    telefoneErrors.value = telefone.value ? [] : ['Telefone is required']
    passwordErrors.value = password.value ? [] : ['Password is required']
    
    try{
      await BE_API.login(Number(telefone.value), password.value);
      telefone.value = "";
      password.value = "";
      router.push('/dashboard');
    }
    catch(error)
    {
      passwordErrors.value = ['Login failed']
    }
  }
</script>
