import { Router } from 'express'
import { middleware as body } from 'bodymen'
import { token } from '../../services/passport'
import { update } from './controller'
import model, { schema } from './model'

const router = new Router()
const { companyName } = schema.tree

export const Organization = model

/**
 * @api {put} /organizations/:id Update Organization
 * @apiName UpdateOrganization
 * @apiGroup Organization
 * @apiPermission admin
 * @apiParam {String} access_token user access_token.
 * @apiParam {String} [id] Org's id.
 * @apiSuccess {Object} Org Org's data.
 * @apiError {Object} 400 Some parameters may contain invalid values.
 * @apiError 404 Org not found.
 */
router.put('/:id',
  token({ required: true, roles: ['admin'] }),
  body({ companyName }),
  update
)

export default router
