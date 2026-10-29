import cds from '@sap/cds'
import { SELECT, UPDATE, INSERT } from '@sap/cds/lib/ql/cds-ql.js'

export default class ServiceDesk extends cds.ApplicationService {

    init() {

        function calcularSLA(createdAt, dataFechamento) {

            const inicio = new Date(createdAt)

            const fim = dataFechamento
                ? new Date(dataFechamento)
                : new Date()

            const horas = (fim - inicio) / (1000 * 60 * 60)

            return {
                slaStatus: horas <= 48
                    ? 'Dentro do SLA'
                    : 'Fora do SLA',

                slaCriticidade: horas <= 48
                    ? 3
                    : 1
            }

        }

        const { Incidentes, Conversas } = this.entities

        this.on('fecharIncidente', async req => {

            const incidenteID = req.params[0].ID

            const incidente = await SELECT.one
                .from(Incidentes)
                .where({ ID: incidenteID })

            if (incidente.status_codigo === 'F') {
                req.reject('O incidente já está fechado.')
            }

            if (!incidente.descricaoResolucao) {
                req.reject('Informe a resolução antes de fechar o incidente!')
            }

            const dataFechamento = new Date()

            const sla = calcularSLA(
                incidente.createdAt,
                dataFechamento
            )

            await UPDATE(Incidentes)
                .set({
                    status_codigo: 'F',
                    dataFechamento,
                    slaStatus: sla.slaStatus,
                    slaCriticidade: sla.slaCriticidade
                })
                .where({ ID: incidenteID })

            await INSERT.into(Conversas).entries({
                mensagem: 'Status alterado para Fechado.',
                incidente_ID: incidenteID,
                cliente_ID: '99999999-9999-9999-9999-999999999999'
            })

        })

        this.on('reabrirIncidente', async req => {

            const incidenteID = req.params[0].ID

            const incidente = await SELECT.one
                .from(Incidentes)
                .where({ ID: incidenteID })

            if (incidente.status_codigo !== 'F') {
                req.reject('Somente incidentes fechados podem ser reabertos.')
            }

            await UPDATE(Incidentes)
                .set({
                    status_codigo: 'P',
                    dataFechamento: null,
                    slaStatus: null,
                    slaCriticidade: null
                })
                .where({ ID: incidenteID })

            await INSERT.into(Conversas).entries({
                mensagem: 'Status alterado para Em andamento.',
                incidente_ID: incidenteID,
                cliente_ID: '99999999-9999-9999-9999-999999999999'
            })

        })

        this.before('CREATE', Incidentes, async req => {

            if (!req.data.status_codigo) {
                req.data.status_codigo = 'N'
            }

            req.data.slaStatus = 'Dentro do SLA'
            req.data.slaCriticidade = 3

        })

        this.before('UPDATE', Incidentes, async req => {

            const incidente = await SELECT.one
                .from(Incidentes)
                .where({ ID: req.data.ID })

            if (incidente?.status_codigo === 'F') {
                req.reject(
                    'Incidentes fechados não podem ser alterados. Reabra o incidente primeiro.'
                )
            }

            if (
                req.data.status_codigo === 'F' &&
                !req.data.descricaoResolucao
            ) {
                req.reject(
                    'Informe a resolução antes de fechar o incidente!'
                )
            }

            if (req.data.status_codigo === 'F') {
                req.data.dataFechamento = new Date()
            }

            if (
                req.data.status_codigo &&
                req.data.status_codigo !== 'F'
            ) {
                req.data.dataFechamento = null
            }

        })

        return super.init()
    }

}