import { Schema as MongooseSchema } from 'mongoose';
import { Schema, Prop, SchemaFactory } from '@nestjs/mongoose';

export type ProductDocument = Product & Document;
@Schema()
export class Product {
  @Prop({ required: true })
  name: string;
  @Prop({ required: true })
  prix: string;
  @Prop({ required: true })
  description: string;
}

export const ProductSchema = SchemaFactory.createForClass(Product);
