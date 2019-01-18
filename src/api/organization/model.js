import mongoose, { Schema } from 'mongoose'
import mongooseKeywords from 'mongoose-keywords'

const organizationSchema = new Schema({
  organizationName: {
    type: String,
    index: true,
    trim: true,
    required: true
  }
}, {
  timestamps: true
})

organizationSchema.methods = {
  view () {
    const { id, organizationName, createdAt } = this
    return {
      id,
      organizationName,
      createdAt
    }
  }
}

organizationSchema.plugin(mongooseKeywords, { paths: ['organizationName'] })

const model = mongoose.model('Organization', organizationSchema)

export const schema = model.schema
export default model
