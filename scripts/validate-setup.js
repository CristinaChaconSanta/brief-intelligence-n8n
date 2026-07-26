#!/usr/bin/env node

/**
 * Brief Intelligence System - Setup Validation Script
 * Este script valida que todas las configuraciones estén correctas
 */

const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');

// Colores para console output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m'
};

class SetupValidator {
  constructor() {
    this.errors = [];
    this.warnings = [];
    this.checks = 0;
    this.passed = 0;
  }

  log(message, type = 'info') {
    const timestamp = new Date().toISOString();
    const color = {
      error: colors.red,
      success: colors.green,
      warning: colors.yellow,
      info: colors.blue
    }[type] || colors.reset;
    
    console.log(`${color}[${timestamp}] ${message}${colors.reset}`);
  }

  check(condition, successMessage, errorMessage) {
    this.checks++;
    if (condition) {
      this.log(`✅ ${successMessage}`, 'success');
      this.passed++;
      return true;
    } else {
      this.log(`❌ ${errorMessage}`, 'error');
      this.errors.push(errorMessage);
      return false;
    }
  }

  warn(condition, message) {
    if (!condition) {
      this.log(`⚠️  ${message}`, 'warning');
      this.warnings.push(message);
    }
  }

  // Validar estructura de archivos
  validateFileStructure() {
    this.log('🔍 Validando estructura de archivos...', 'info');
    
    const requiredFiles = [
      'workflows/brief-intelligence-main.json',
      'config/llm-config.json',
      'config/supabase-config.json',
      'config/apis-config.json',
      'config/teams-mapping.json',
      'prompts/extractor-prompt.txt',
      'prompts/validator-prompt.txt',
      'prompts/change-processor-prompt.txt',
      'schemas/brief-schema.json',
      'schemas/validation-schema.json',
      'supabase/schema.sql',
      'templates/email-approval.html',
      'templates/email-team-notification.html',
      'templates/slack-approval.json',
      'templates/slack-team-notification.json'
    ];

    requiredFiles.forEach(file => {
      const filePath = path.join(__dirname, '..', file);
      this.check(
        fs.existsSync(filePath),
        `Archivo encontrado: ${file}`,
        `Archivo faltante: ${file}`
      );
    });

    // Verificar .env
    const envPath = path.join(__dirname, '..', '.env');
    this.check(
      fs.existsSync(envPath),
      'Archivo .env encontrado',
      'Archivo .env no encontrado - copiar desde .env.example'
    );
  }

  // Validar variables de entorno
  validateEnvironmentVariables() {
    this.log('🔍 Validando variables de entorno...', 'info');
    
    const requiredEnvVars = [
      'GEMINI_API_KEY',
      'SUPABASE_URL',
      'SUPABASE_ANON_KEY',
      'GMAIL_CLIENT_ID',
      'TELEGRAM_BOT_TOKEN',
      'SLACK_BOT_TOKEN',
      'DIRECTOR_EMAIL',
      'N8N_WEBHOOK_URL'
    ];

    requiredEnvVars.forEach(envVar => {
      this.check(
        process.env[envVar] && process.env[envVar] !== 'your-key-here',
        `Variable de entorno configurada: ${envVar}`,
        `Variable de entorno faltante o no configurada: ${envVar}`
      );
    });

    // Validaciones adicionales
    this.warn(
      process.env.OPENAI_API_KEY && process.env.OPENAI_API_KEY !== 'your-openai-api-key-here',
      'OpenAI API Key no configurada - solo funcionará Gemini'
    );

    this.warn(
      process.env.SUPABASE_SERVICE_ROLE_KEY,
      'Supabase Service Role Key no configurada - funcionalidad limitada'
    );
  }

  // Validar configuración JSON
  validateJsonConfigs() {
    this.log('🔍 Validando configuraciones JSON...', 'info');
    
    const jsonFiles = [
      'config/llm-config.json',
      'config/supabase-config.json', 
      'config/apis-config.json',
      'config/teams-mapping.json',
      'schemas/brief-schema.json',
      'schemas/validation-schema.json'
    ];

    jsonFiles.forEach(file => {
      try {
        const filePath = path.join(__dirname, '..', file);
        const content = fs.readFileSync(filePath, 'utf8');
        JSON.parse(content);
        this.check(true, `JSON válido: ${file}`, '');
      } catch (error) {
        this.check(false, '', `JSON inválido en ${file}: ${error.message}`);
      }
    });

    // Validar configuración específica de LLM
    try {
      const llmConfigPath = path.join(__dirname, '..', 'config/llm-config.json');
      const llmConfig = JSON.parse(fs.readFileSync(llmConfigPath, 'utf8'));
      
      this.check(
        llmConfig.active_provider && ['gemini', 'openai'].includes(llmConfig.active_provider),
        `Provider LLM válido: ${llmConfig.active_provider}`,
        'Provider LLM no válido en llm-config.json'
      );

      this.check(
        llmConfig.providers && llmConfig.providers.gemini && llmConfig.providers.openai,
        'Configuración de providers completa',
        'Configuración de providers incompleta en llm-config.json'
      );
    } catch (error) {
      this.log(`Error validando llm-config.json: ${error.message}`, 'error');
    }
  }

  // Validar conexión a Supabase
  async validateSupabaseConnection() {
    this.log('🔍 Validando conexión a Supabase...', 'info');
    
    try {
      if (!process.env.SUPABASE_URL || !process.env.SUPABASE_ANON_KEY) {
        this.check(false, '', 'Credenciales de Supabase no configuradas');
        return;
      }

      const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_ANON_KEY);
      
      // Test de conexión básica
      const { data, error } = await supabase.from('briefs').select('id').limit(1);
      
      if (error) {
        this.check(false, '', `Error conectando a Supabase: ${error.message}`);
      } else {
        this.check(true, 'Conexión a Supabase exitosa', '');
      }

      // Verificar que las tablas existan
      const tables = ['briefs', 'brief_cambios', 'brief_aprobaciones', 'system_logs'];
      for (const table of tables) {
        try {
          await supabase.from(table).select('*').limit(1);
          this.check(true, `Tabla existe: ${table}`, '');
        } catch (error) {
          this.check(false, '', `Tabla no existe o no accesible: ${table}`);
        }
      }
    } catch (error) {
      this.check(false, '', `Error general conectando a Supabase: ${error.message}`);
    }
  }

  // Validar APIs externas
  async validateExternalAPIs() {
    this.log('🔍 Validando APIs externas...', 'info');
    
    // Test Gemini API
    if (process.env.GEMINI_API_KEY) {
      try {
        const response = await fetch(`https://generativelanguage.googleapis.com/v1/models?key=${process.env.GEMINI_API_KEY}`);
        this.check(
          response.ok,
          'Gemini API accesible',
          'Error accediendo a Gemini API'
        );
      } catch (error) {
        this.check(false, '', `Error probando Gemini API: ${error.message}`);
      }
    }

    // Test OpenAI API
    if (process.env.OPENAI_API_KEY) {
      try {
        const response = await fetch('https://api.openai.com/v1/models', {
          headers: {
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
          }
        });
        this.check(
          response.ok,
          'OpenAI API accesible',
          'Error accediendo a OpenAI API'
        );
      } catch (error) {
        this.check(false, '', `Error probando OpenAI API: ${error.message}`);
      }
    }
  }

  // Validar templates
  validateTemplates() {
    this.log('🔍 Validando templates...', 'info');
    
    // Validar HTML templates
    const htmlFiles = [
      'templates/email-approval.html',
      'templates/email-team-notification.html'
    ];

    htmlFiles.forEach(file => {
      try {
        const filePath = path.join(__dirname, '..', file);
        const content = fs.readFileSync(filePath, 'utf8');
        
        // Verificar que contenga placeholders básicos
        const requiredPlaceholders = ['{{cliente', '{{proyecto', '{{webhook_url}}'];
        const hasPlaceholders = requiredPlaceholders.some(placeholder => 
          content.includes(placeholder)
        );
        
        this.check(
          hasPlaceholders,
          `Template HTML válido: ${file}`,
          `Template HTML sin placeholders: ${file}`
        );
      } catch (error) {
        this.check(false, '', `Error validando template ${file}: ${error.message}`);
      }
    });

    // Validar JSON templates de Slack
    const slackFiles = [
      'templates/slack-approval.json',
      'templates/slack-team-notification.json'
    ];

    slackFiles.forEach(file => {
      try {
        const filePath = path.join(__dirname, '..', file);
        const content = fs.readFileSync(filePath, 'utf8');
        const parsed = JSON.parse(content);
        
        this.check(
          parsed.blocks && Array.isArray(parsed.blocks),
          `Template Slack válido: ${file}`,
          `Template Slack inválido: ${file}`
        );
      } catch (error) {
        this.check(false, '', `Error validando template Slack ${file}: ${error.message}`);
      }
    });
  }

  // Generar reporte final
  generateReport() {
    this.log('\n📊 REPORTE DE VALIDACIÓN', 'info');
    this.log('='.repeat(50), 'info');
    
    this.log(`Total de verificaciones: ${this.checks}`, 'info');
    this.log(`Verificaciones exitosas: ${this.passed}`, 'success');
    this.log(`Errores encontrados: ${this.errors.length}`, 'error');
    this.log(`Advertencias: ${this.warnings.length}`, 'warning');

    if (this.errors.length > 0) {
      this.log('\n❌ ERRORES CRÍTICOS:', 'error');
      this.errors.forEach((error, index) => {
        this.log(`${index + 1}. ${error}`, 'error');
      });
    }

    if (this.warnings.length > 0) {
      this.log('\n⚠️  ADVERTENCIAS:', 'warning');
      this.warnings.forEach((warning, index) => {
        this.log(`${index + 1}. ${warning}`, 'warning');
      });
    }

    const successRate = Math.round((this.passed / this.checks) * 100);
    this.log(`\n🎯 Tasa de éxito: ${successRate}%`, successRate >= 80 ? 'success' : 'error');

    if (successRate >= 90) {
      this.log('\n🎉 ¡Sistema listo para usar!', 'success');
    } else if (successRate >= 70) {
      this.log('\n⚠️  Sistema parcialmente configurado - revisar errores', 'warning');
    } else {
      this.log('\n❌ Sistema necesita configuración adicional', 'error');
    }
  }

  // Ejecutar todas las validaciones
  async runAllValidations() {
    this.log('🚀 Iniciando validación del Brief Intelligence System...', 'info');
    this.log('='.repeat(60), 'info');

    this.validateFileStructure();
    this.validateEnvironmentVariables();
    this.validateJsonConfigs();
    this.validateTemplates();
    
    await this.validateSupabaseConnection();
    await this.validateExternalAPIs();

    this.generateReport();
    
    return {
      totalChecks: this.checks,
      passed: this.passed,
      errors: this.errors.length,
      warnings: this.warnings.length,
      successRate: Math.round((this.passed / this.checks) * 100)
    };
  }
}

// Ejecutar validación si se llama directamente
if (require.main === module) {
  // Cargar variables de entorno
  require('dotenv').config();
  
  const validator = new SetupValidator();
  validator.runAllValidations()
    .then(result => {
      process.exit(result.successRate >= 70 ? 0 : 1);
    })
    .catch(error => {
      console.error('Error durante la validación:', error);
      process.exit(1);
    });
}

module.exports = SetupValidator;